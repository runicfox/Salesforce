@isTest
private with sharing class ServiceTerritoryAssignmentTest { 
    @testSetup
    static void setup() {
        List<Account>  listOfAccounts = TestDataFactory.createAccounts(3);
        List<FSA_Service_Territory_Mapping__c> listOfFSAServiceTerritory = new List<FSA_Service_Territory_Mapping__c>();
        listOfFSAServiceTerritory = TestDataFactory.createFSAServiceTerritoryMapping();
        insert listOfFSAServiceTerritory;
        for(Account ac : listOfAccounts){
            ac.Subsidiary__c ='CA';
            ac.Service_Territory__c = null;
        }
        insert listOfAccounts;
    }
 
    @isTest
    static void testSetServiceTerritoryIns() {
        test.startTest();
            List<FSA_Service_Territory_Mapping__c> listOfsTy = [SELECT Id,Name FROM FSA_Service_Territory_Mapping__c];
            system.assertEquals(listOfsTy.size(), 3);
            List<Account> listOfAccount = [SELECT Id,Name FROM Account];
            system.assertEquals(listOfAccount.size(), 3);
        test.stopTest();
    }    
}