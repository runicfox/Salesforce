@isTest
private with sharing class ServiceTerritoryAssignmentTest { 
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        List<FSA_Service_Territory_Mapping__c> listOfFSAServiceTerritory = new List<FSA_Service_Territory_Mapping__c>();
        listOfFSAServiceTerritory = TestDataFactory.createFSAServiceTerritoryMapping();
        insert listOfFSAServiceTerritory;
        accounts = TestDataFactory.createAcocuntWithSubsidiaryCA();
        insert accounts;
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