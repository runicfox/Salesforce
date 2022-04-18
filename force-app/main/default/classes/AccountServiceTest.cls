@isTest
public with sharing class AccountServiceTest {
    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(3);
        insert accounts[0];

        accounts[1].ParentId = accounts[0].Id;
        insert accounts[1];
    }

    @isTest
    static void testAccountGetAccountById() {
        Account expectedAccount = [
            SELECT Id, Name, ParentId, Parent.Name
            FROM Account
            LIMIT 1
        ];
        Account actualAccount = AccountService.getAccountById(
            expectedAccount.Id
        );

        List<SObjectField> fields = new List<SObjectField>{
            Account.Id,
            Account.Name,
            Account.ParentId
        };

        for (SObjectField field : fields) {
            System.assertEquals(
                expectedAccount.get(field),
                actualAccount.get(field),
                field.getDescribe().getLabel() + ' value not matched.'
            );
        }

        System.assertEquals(
            expectedAccount.Parent.Name,
            actualAccount.Parent.Name,
            'Parent.Name value not matched.'
        );
    }

    @isTest
    static void testAccountUpdate() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 1];
        accounts[0].Name = accounts[0].Name + ' x';

        Database.SaveResult[] results = AccountService.updateAccounts(
            accounts,
            true
        );

        System.assertEquals(
            true,
            results[0].isSuccess(),
            'Account was not updated successfully.'
        );

        accounts[0].Name = null;
        Boolean exceptionThrown = false;
        try {
            results = AccountService.updateAccounts(accounts, true);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        System.assert(exceptionThrown, 'Exception was not rethrown.');
    }
}