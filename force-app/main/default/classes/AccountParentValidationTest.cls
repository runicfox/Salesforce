@isTest
private class AccountParentValidationTest {
    
    static testmethod void ValidateAccountforParent_test(){
        //When account will be validate then trigger will return same error message,To check condition while trigger will return error.
        String message ='This account cannot have a parent as either it has children or the parent has a parent. View the hierarchy of this account or the parent you are trying to associate for more information.” ';
        // Prospect Record type Id
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<Account> listOfAccount = TestingUtils.createAccounts(5,prospectRecordTypeId);
        insert listOfAccount;
        
        listOfAccount[1].ParentId = listOfAccount[0].Id;
        Account account2 = listOfAccount[1];
        update account2;
        
        Account accountobj = TestingUtils.createAccounts(1,prospectRecordTypeId)[0];
        accountobj.ParentId = listOfAccount[0].Id;
        insert accountobj;
        
        Account account1 =  listOfAccount[0]; 
        Boolean isError = false;
        Test.startTest();
            Database.SaveResult saveResultList;
            account1.ParentId = account2.Id;
            saveResultList = Database.update(account1,false);
            for(Database.Error e : saveResultList.errors){
                String errorMessage  = e.getMessage();
                if(errorMessage.equals(message)){
                    isError = true;
                }
            }
            System.assertEquals(true,isError);
            Account  account4 = listOfAccount[3];
            account4.ParentId = accountobj.Id;
            saveResultList = Database.update(account4,false);
            for(Database.Error e : saveResultList.errors){
                String errorMessage  = e.getMessage();
                if(errorMessage.equals(message)){
                    isError = true;
                }
            }
            System.assertEquals(true,isError);
            Account  account5 = listOfAccount[4];
            account5.ParentId = account1.id;
            update account5;
            Account acc = [Select isParent__c from Account where id =: account1.Id];
            System.assert(acc.IsParent__c); 
        Test.stopTest();
    }    
}