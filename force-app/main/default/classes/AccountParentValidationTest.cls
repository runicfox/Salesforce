@isTest
private class AccountParentValidationTest {
    
    static testmethod void ValidateAccountforParent_test(){
        
        // Prospect Record type Id
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<Account> listOfAccount = TestingUtils.createAccounts(2,prospectRecordTypeId);
        insert listOfAccount;
        
        listOfAccount[1].ParentId = listOfAccount[0].Id;
        Account account2 = listOfAccount[1];
        update account2;
        
        Account account3 = TestingUtils.createAccounts(1,prospectRecordTypeId)[0];
        account3.ParentId = listOfAccount[0].Id;
        insert account3;
        
        Account account4 = TestingUtils.createAccounts(1,prospectRecordTypeId)[0];
        insert account4;
        
        Account account5 = TestingUtils.createAccounts(1,prospectRecordTypeId)[0];
        insert account5;
        
        Account account1 = listOfAccount[0];
        Boolean isError = false;
        Test.startTest();
            account1.ParentId = account3.Id;
            Database.SaveResult accErrorList = Database.update(account1,false);
            for(Database.Error e : accErrorList.errors){
                if(e.getMessage() != null || e.getMessage() != ''){
                    isError = true;
                }
            }
            System.assertEquals(true,isError);
            account4.ParentId = account2.Id;
            Database.SaveResult accErrorList2 = Database.update(account4,false);
            for(Database.Error e : accErrorList2.errors){
                if(e.getMessage() != null || e.getMessage() != ''){
                    isError = true;
                }
            }
            System.assertEquals(true,isError);
            account5.ParentId = account1.id;
            update account5;
            Account acc = [Select isParent__c from Account where id =: account1.Id];
            System.assertEquals(account5.ParentId,account1.Id); 
        Test.stopTest();
    }    
}