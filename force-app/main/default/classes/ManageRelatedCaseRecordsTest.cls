@isTest(SeeAllData=true)
public class ManageRelatedCaseRecordsTest {

    @isTest static void testCaseAfterInsert(){
        Field_Service_Settings__c fssetting = Field_Service_Settings__c.getOrgDefaults();
        
        Opportunity op = [SELECT Id, Name, AccountId, StageName, Site_Survey__c, Seasonal_Requirements__c, Description, RecordTypeId FROM Opportunity 
                          WHERE Account.ParentId !=null AND Account.On_Hold__c = false AND Account.RecordType.DeveloperName = 'Customer_Ship_To' AND StageName='Presentation' Limit 1];
        
        op.RecordTypeId = fssetting.Opportunity_RecordType_Frequency_Change__c;
        op.StageName = fssetting.Opportunity_Frequency_Change_Stage_Name__c;
        update op;
        
		Case c = [SELECT Id,  Opportunity__c, RecordType.DeveloperName, Status FROM Case WHERE Opportunity__c =: op.Id];
        c.Status = 'Rejected';
        
        Test.startTest();
        update c;
        Test.stopTest();
        
        Opportunity opp = [SELECT Id, Name, AccountId, StageName FROM Opportunity WHERE Id =: op.Id];
        System.assertEquals(fssetting.Opportunity_Case_Rejection_Stage_Name__c, opp.StageName);
    }
}