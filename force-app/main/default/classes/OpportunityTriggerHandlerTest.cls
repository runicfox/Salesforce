@isTest
public class OpportunityTriggerHandlerTest {
    static testMethod void updateInsertBillToShipToAccounts_Scenario1Test() {
        Id billToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Bill To')
            .getRecordTypeId();
        Id ShipToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Ship To')
            .getRecordTypeId();

        TestDataFactory.crtOperatingHrs();
        TestDataFactory.crtSrvTerritory();
        TestDataFactory.crtTimeZoneSettings();
        TestDataFactory.crtFieldServiceSetting();
        TestDataFactory.crtProspectAcctContact(1, 1);
        TestDataFactory.crtProdWithPE(3);
        TestDataFactory.crtApprovedSiteSurvey(1);

        // Test Scenario where Opportunity belongs to a prospect account without parent (Bill To)
        TestDataFactory.crtOpportunities(
            1,
            TestDataFactory.accounts[0],
            TestDataFactory.contacts[0].Id
        );
        TestDataFactory.opportunities[0]
            .StageName = TestDataFactory.fssetting.Opportunity_Case_Creation_Stage_Name__c;
        update TestDataFactory.opportunities[0];
        TestDataFactory.crtTestUsers(1);
        Test.startTest();
        System.runAs(TestDataFactory.lUsers.get(0)) {
            TestDataFactory.opportunities[0]
                .StageName = TestDataFactory.fssetting.Opportunity_To_Order_Creation_Stage_Name__c;
            update TestDataFactory.opportunities[0];

            Account acct = [
                SELECT Id, Type
                FROM Account
                WHERE Id = :TestDataFactory.accounts[0].Id
            ];
            System.assertEquals('Customer', acct.Type);
        }
        Test.stopTest();
    }

    static testMethod void updateInsertBillToShipToAccounts_Scenario2Test() {
        Id billToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Bill To')
            .getRecordTypeId();
        Id ShipToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Ship To')
            .getRecordTypeId();

        TestDataFactory.crtOperatingHrs();
        TestDataFactory.crtSrvTerritory();
        TestDataFactory.crtTimeZoneSettings();
        TestDataFactory.crtFieldServiceSetting();
        TestDataFactory.crtProspectAcctContact(2, 1);
        TestDataFactory.crtProdWithPE(3);
        TestDataFactory.crtApprovedSiteSurvey(1);

        // Test the scenario If the Account has a Parent and the Parent is a Prospect Account
        TestDataFactory.accounts[0].parentId = TestDataFactory.accounts[1].Id;
        update TestDataFactory.accounts[0];
        TestDataFactory.crtOpportunities(
            1,
            TestDataFactory.accounts[0],
            TestDataFactory.contacts[0].Id
        );
        TestDataFactory.opportunities[0]
            .StageName = TestDataFactory.fssetting.Opportunity_Case_Creation_Stage_Name__c;
        update TestDataFactory.opportunities[0];
        TestDataFactory.crtTestUsers(1);

        Test.startTest();
        System.runAs(TestDataFactory.lUsers.get(0)) {
            TestDataFactory.opportunities[0]
                .StageName = TestDataFactory.fssetting.Opportunity_To_Order_Creation_Stage_Name__c;
            update TestDataFactory.opportunities[0];

            Account acct = [
                SELECT Id, Type
                FROM Account
                WHERE Id = :TestDataFactory.accounts[0].Id
            ];
            System.assertEquals('Customer', acct.Type);
        }
        Test.stopTest();
    }

    static testMethod void updateInsertBillToShipToAccounts_Scenario3Test() {
        Id billToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Bill To')
            .getRecordTypeId();
        Id ShipToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Ship To')
            .getRecordTypeId();

        TestDataFactory.crtOperatingHrs();
        TestDataFactory.crtSrvTerritory();
        TestDataFactory.crtTimeZoneSettings();
        TestDataFactory.crtFieldServiceSetting();
        TestDataFactory.crtProspectAcctContact(2, 1);
        TestDataFactory.crtProdWithPE(3);
        TestDataFactory.crtApprovedSiteSurvey(1);

        // Test the scenario If the Account has a Parent and the Parent is a Bill To Account
        TestDataFactory.accounts[0].parentId = TestDataFactory.accounts[1].Id;
        TestDataFactory.accounts[1].RecordTypeId = billToAcctRecTypeId;
        TestDataFactory.accounts[1].Type = 'Customer';
        update TestDataFactory.accounts[0];
        update TestDataFactory.accounts[1];
        TestDataFactory.crtOpportunities(
            1,
            TestDataFactory.accounts[0],
            TestDataFactory.contacts[0].Id
        );
        TestDataFactory.opportunities[0]
            .StageName = TestDataFactory.fssetting.Opportunity_Case_Creation_Stage_Name__c;
        update TestDataFactory.opportunities[0];
        TestDataFactory.crtTestUsers(1);

        Test.startTest();
        System.runAs(TestDataFactory.lUsers.get(0)) {
            TestDataFactory.opportunities[0]
                .StageName = TestDataFactory.fssetting.Opportunity_To_Order_Creation_Stage_Name__c;
            update TestDataFactory.opportunities[0];

            Account acct = [
                SELECT Id, Type
                FROM Account
                WHERE Id = :TestDataFactory.accounts[0].Id
            ];
            System.assertEquals('Customer', acct.Type);
        }
        Test.stopTest();
    }
    static testMethod void updateOpportunityCloseRejected() {
        Id billToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Bill To')
            .getRecordTypeId();
        Id ShipToAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
            .get('Customer Ship To')
            .getRecordTypeId();

        TestDataFactory.crtOperatingHrs();
        TestDataFactory.crtSrvTerritory();
        TestDataFactory.crtTimeZoneSettings();
        TestDataFactory.crtFieldServiceSetting();
        TestDataFactory.crtProspectAcctContact(2, 1);
        TestDataFactory.crtProdWithPE(3);
        TestDataFactory.crtApprovedSiteSurvey(1);

        // Test the scenario If the Account has a Parent and the Parent is a Bill To Account
        TestDataFactory.accounts[0].parentId = TestDataFactory.accounts[1].Id;
        TestDataFactory.accounts[1].RecordTypeId = billToAcctRecTypeId;
        TestDataFactory.accounts[1].Type = 'Customer';
        update TestDataFactory.accounts[0];
        update TestDataFactory.accounts[1];

        TestDataFactory.crtOpportunities(
            1,
            TestDataFactory.accounts[0],
            TestDataFactory.contacts[0].Id
        );
        TestDataFactory.opportunities[0]
            .RecordTypeId = TestDataFactory.fssetting.Opportunity_RecordType_Frequency_Change__c;
        TestDataFactory.opportunities[0]
            .StageName = TestDataFactory.fssetting.Opportunity_Frequency_Change_Stage_Name__c;
        update TestDataFactory.opportunities[0];

        TestDataFactory.crtTestUsers(1);
        Id oppId = TestDataFactory.opportunities[0].Id;
        Opportunity opp = [
            SELECT Id, StageName, RecordTypeId
            FROM Opportunity
            WHERE Id = :oppId
        ];

        case c = [
            SELECT Id, Status, Subject
            FROM Case
            WHERE Opportunity__c = :oppId
        ];

        c.Status = TestDataFactory.fssetting.Site_Survey_Case_Rejected_Status__c;
        update c;

        Test.startTest();

        opp = [
            SELECT Id, StageName, RecordTypeId
            FROM Opportunity
            WHERE Id = :oppId
        ];

        TestDataFactory.opportunities[0]
            .StageName = TestDataFactory.fssetting.Opportunity_Frequency_Change_Stage_Name__c;
        update TestDataFactory.opportunities[0];

        c = [
            SELECT Id, Status, Subject
            FROM Case
            WHERE Opportunity__c = :oppId
        ];
        System.assertEquals('New', c.Status);
        Test.stopTest();
    }
}