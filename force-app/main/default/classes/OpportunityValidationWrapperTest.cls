

@isTest
public with sharing class OpportunityValidationWrapperTest {

    static testMethod void validateOpportunitiesBeforeInsertMethod() {
        
        test.startTest();
        Group testGroup = new Group(Name = 'Customer_Success', type = 'Queue');
        insert testGroup;
        QueueSObject mappingObject = new QueueSobject(QueueId = testGroup.Id, SObjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert mappingObject;
        }

        Field_Service_Settings__c fssetting = new Field_Service_Settings__c();
        fssetting.Account_Ship_To_Record_Type_Id__c = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Ship To').getRecordTypeId();
        fssetting.Ticket_Emergency_Record_Type__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Emergency').getRecordTypeId();
        fssetting.Customer_Success_Queue__c = testGroup.Id;
        fssetting.Standard_Pricebook_Id__c = Test.getStandardPricebookId();
        fssetting.Regular_Order_Draft_Stage__c = 'Draft';
        fssetting.Pest_LOB__c = 'Pest Control';
        fssetting.Non_Recurring_Frequency_Value__c = 'One-Time';
        fssetting.Work_Order_Dispatched_Status__c = null; //'Dispatched';
        fssetting.Work_Order_Scheduled_Status__c = 'Scheduled';
        fssetting.Working_Hour_End_Time__c = '4:00';
        fssetting.Cannot_Complete_Status_Value__c = 'Cannot Complete';
        fssetting.System_Administrator_Profile_Id__c = UserInfo.getProfileId();
        fssetting.Work_Order_Cancelled_Status__c = 'Cancelled';
        fssetting.CitronDoNotReply__c = 'donotreply@citronhygiene.com.staging';
        fssetting.Customer_Success_Queue__c = testGroup.Id;
        fssetting.Ticket_New_Status__c = 'New';
        fssetting.PO_Required_Before_Label__c = 'PO Required Before';
        fssetting.Opportunity_To_Order_Creation_Stage_Name__c = 'Presentation';
        insert fssetting;

        // Account creation
        account acc = new account(Name = 'TEST_ACCOUNT', Lead_Source__c = 'Blitz Day', Phone = '1234567890', BillingCountry = 'CA',
            BillingState = 'ON', BillingCity = 'Toronto', Subsidiary__c = 'CA', Type = 'Prospect', Account_Type__c = 'Programmer');
        insert acc;
        
        //Contact creation 
        Contact con = new contact(lastname = 'Test_Contact', AccountId = acc.Id, Status__c = 'Active');
        insert con;
        
        //Opportunity creations
        Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Conversion Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = acc.Name + ' Opportunity ';
        opp.AccountId = acc.Id;
        opp.StageName = 'Presentation';
        opp.CloseDate = System.today().addDays(30);
        opp.Amount = 0.0;
        opp.Type = 'Retention';
        opp.Opportunity_Type__c = 'Consumables';
        opp.LeadSource = 'Call In';
        opp.RecordTypeId = newRecordTypeId;
        insert opp;

        Opportunity opp1 = new Opportunity();
        opp1.Name = acc.Name + ' Opportunity1 ';
        opp1.AccountId = acc.Id;
        opp1.StageName = 'Presentation';
        opp1.CloseDate = System.today().addDays(30);
        opp1.Amount = 0.0;
        opp1.Type = 'Retention';
        opp1.Opportunity_Type__c = 'Consumables';
        opp1.LeadSource = 'Call In';
        opp1.RecordTypeId = newRecordTypeId;
        insert opp1;
                
        // opportunitycontactRole creations
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = con.Id;
        ocr.OpportunityId = opp.Id;
        ocr.IsPrimary = false;
        ocr.Role = 'Decision Maker';
        insert ocr;
        ocr.IsPrimary = true;
        update ocr;
       
        // Opportunity update 
        opp.Amount = 1.0;
        opp.StageName = 'Proposal';
        update opp;
        opp1.Amount = 1.0;
        update opp1;
        
        test.stopTest();

    }
}