@isTest(SeeAllData=true)
public class ManageRelatedCaseRecordsTest {
    
    static void setup() {
        List<OrderItem> orderItems = new List<OrderItem>();
        List<Product2> products = new List<Product2>();
        List<PricebookEntry> pEntries = new List<PricebookEntry>();
        List<Survey_Asset_Location__c> surveyAssetLocations = new List<Survey_Asset_Location__c>();
        List<OpportunityLineItem> oppItems = new List<OpportunityLineItem>();
        List<String> frequencies = new List<String>{'One-Time','Monthly','Weekly'};
            Id pBook = Test.getStandardPricebookId();
        Id internalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Data Review').getRecordTypeId();
        String sysAdminProfileId = [SELECT Id FROM Profile WHERE Name ='System Administrator' LIMIT 1].Id;
        
        Group testGroup = new Group(Name='TestGroup', Type='Queue');
        insert testGroup;
        

        
        
        TestDataFactory.crtAcctContact(1, 1); 
        
        Account a = TestDataFactory.accounts[0]; 
        a.OperatingHoursId = TestDataFactory.opthours[1].id; 
        a.Service_Territory__c = TestDataFactory.srvTers[1].id;
        a.Type = 'Prospect';
        a.AccPac_Account__c = '';
        update a; 
        
        Contact c = TestDataFactory.contacts[0];
        
        Site_Survey__c ss = new Site_Survey__c(
            Account__c=a.Id, 
            Survey_Date__c = System.today(),
            Status__c = 'Approved'
        );
        insert ss;
        
        Survey_Location__c location = new Survey_Location__c(
            Site_Survey__c=ss.Id, 
            Building__c = 'Building',
            Floor__c = 'Floor', 
            Location_Type__c='Washroom', 
            Location_SubType__c='Unisex',
            Name='Location'
        );
        insert location;
        
        a.Site_Survey__c = ss.Id;
        update a;
        
        for(Integer i=0; i<5; i++){
            products.add(
                new Product2(
                    Name='TestProduct'+i,
                    Allowable_Frequencies__c='One-Time;Monthly;Weekly', 
                    IsActive=TRUE, 
                    Available_As_Related_Product__c=TRUE, 
                    Family= (i==1) ? 'Pest Control' : 'Hygiene'
                )       
            );
        }
        
        insert products;
        
        for(Integer i=0; i<5; i++) {
            pEntries.add(
                new PricebookEntry(
                    Pricebook2Id=pBook, 
                    Product2Id=products.get(i).Id, 
                    UnitPrice=1.0, 
                    IsActive=TRUE
                )
            );
        }
        insert pEntries; 
        
        Opportunity op = new Opportunity(
            Name=a.Name+' Opportunity',
            AccountId=a.Id,
            StageName='Presentation', 
            CloseDate=System.today().addDays(30),
            Amount=0.0, 
            pricebook2Id = pBook,
            Type='Retention', 
            Opportunity_Type__c='Consumables', 
            LeadSource='Call In', 
            Site_Survey__c=a.Site_Survey__c
        ); 
        insert op;
        
        OpportunityContactRole oppRole = new OpportunityContactRole(
            OpportunityId=op.Id,
            ContactId=c.Id, 
            Role='Decision Maker',
            isPrimary=TRUE
        );
        insert oppRole;
        
        for(Integer i=0; i<3; i++) {
            oppItems.add(
                new OpportunityLineItem(
                    Product2Id=pEntries.get(i).Id,  
                    Service_Frequency__c=frequencies.get(i), 
                    UnitPrice=1.0, 
                    Service_Price_Per_Unit__c=1.0, 
                    Quantity=1, 
                    OpportunityId=op.Id, 
                    SurveyAssetCountChecker__c=1
                )
            );
        } 
        insert oppItems;
        
        for(Integer i=0; i<3; i++) {
            surveyAssetLocations.add(
                new Survey_Asset_Location__c(
                    Originating_Parent_ID__c=op.Id,  
                    Originating_Record_ID__c=oppItems.get(i).Id, 
                    Product__c=products.get(i).Id, 
                    Quantity__c=1, 
                    Site_Survey__c=op.Site_Survey__c, 
                    Service_Frequency__c=oppItems.get(i).Service_Frequency__c, 
                    Survey_Location__c=location.Id
                )
            );
        }
        insert surveyAssetLocations;
        
        User newUser = new User(
            Alias = 'testA', 
            Email = 'testUser@UserCommunity.com', 
            EmailEncodingKey = 'ISO-8859-1', 
            FirstName = 'TestFirstName',
            LastName = 'TestLastName', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_CA', 
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/New_York', 
            UserName = 'testUser@UserCommunity.com',
            Employee_Number__c = 'ABCD123TEST'
        );
        insert newUser;
        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Case');
        
        
        System.runAs(newUser) {
            insert testQueue;
        }
    }
    
    @isTest static void testCaseAfterInsert(){
        setup();
        Field_Service_Settings__c fssetting = Field_Service_Settings__c.getOrgDefaults();
        
        Opportunity op = [SELECT Id, Name, AccountId, StageName, Site_Survey__c, Seasonal_Requirements__c, Description, RecordTypeId FROM Opportunity 
                          WHERE Name like '%Opportunity%' AND StageName='Presentation' LIMIT 1];
        
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