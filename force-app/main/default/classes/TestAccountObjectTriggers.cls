@IsTest
public class TestAccountObjectTriggers {
    
    @TestSetup static void setup() {
        Date todaysDate = System.today();
        List<Account> accounts = new List<Account>();
        List<Site_Survey__c> siteSurveys = new List<Site_Survey__c>();
        
        String sysAdminProfileId = [SELECT Id FROM Profile WHERE Name ='System Administrator' LIMIT 1].Id;
        String randomProfileId = [SELECT Id, UserType FROM Profile WHERE Id !=:sysAdminProfileId AND UserType != 'PowerCustomerSuccess' LIMIT 1].Id;
        String customerSuccessProfileId = [SELECT Id FROM Profile WHERE Id!=:sysAdminProfileId AND Id!=:randomProfileId LIMIT 1].Id;
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1]; 
        
        Group testGroup = new Group(Name='Billing_Team', type='Queue');
        insert testGroup;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = testGroup.Id, SObjectType = 'Case');
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
        	insert mappingObject;
        }
        
        Field_Service_Settings__c fssetting = new Field_Service_Settings__c();
        fssetting.System_Administrator_Profile_Id__c = sysAdminProfileId;
        fssetting.Customer_Service_Profile_Id__c = customerSuccessProfileId;
        fssetting.Operating_Hours_Type_Account__c = 'Account Operating Hours';
        fssetting.Invoice_Information_Case_RecordTypeId__c = '012f1000000PUJKAA4';
        fssetting.Billing_Queue__c = testGroup.Id;
        fssetting.Integration_User_Id__c = adminUser.Id;
        insert fssetting;
        
        TestDataFactory.crtAcctContact(4, 1);
        accounts = TestDataFactory.accounts;
        List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND IsActive = TRUE];
        List<Account> insertedAccounts = TestDataFactory.createAccounts();
        for(Integer i=0; i<insertedAccounts.size(); i++) {
            insertedAccounts[i].RecordTypeId = recordTypes[i].Id;
        }
        insert insertedAccounts;
    }
    
    
    @isTest static void assignSubsidiary() {
        List<Account> accounts = [SELECT Id,RecordType.Name, Subsidiary__c FROM Account];
        for(Account acc: accounts) {
            switch on acc.RecordType.Name {
                when 'US' {
                    System.assertEquals('US', acc.Subsidiary__c, 'US Subsidiary value not correctly assigned for Record Type ' + acc.RecordType.Name);
                }
                when 'UK' {
                    System.assertEquals('UK', acc.Subsidiary__c, 'UK Subsidiary value not correctly assigned for Record Type ' + acc.RecordType.Name);
                }
                when else {
                    System.assertEquals('CA', acc.Subsidiary__c, 'CA Subsidiary value not correctly assigned for Record Type ' + acc.RecordType.Name);
                }
            }
        }
    }
    
    static testMethod void testStampRegion() {
        Map <String, FSA_To_Postal_Code__mdt> fsaToPostalCodeMap = FSA_To_Postal_Code__mdt.getAll();
        Map<String, Id> fsaMapping = new Map<String, Id>();
        List<FSA_Service_Territory_Mapping__c> fsaList = [SELECT Id, FSA__c FROM FSA_Service_Territory_Mapping__c LIMIT 4];
        for(FSA_Service_Territory_Mapping__c f: fsaList) {
            fsaMapping.put(f.FSA__c, f.Id);
        }
        Test.startTest();
        List<Account> accounts = [
            SELECT Id, Subsidiary__c , ShippingPostalCode, FSA_Mapping__c, FSA_Mapping__r.FSA__c FROM Account
            WHERE Name LIKE 'testStampRegion%'
            LIMIT 4
        ];
        for (Account account : accounts) {
            if (account.Subsidiary__c  == null) {
                System.assertEquals(null, account.FSA_Mapping__c);
            } else {
                System.assertEquals(
                    fsaMapping.get(account.ShippingPostalCode.toUpperCase().left(Integer.valueOf(fsaToPostalCodeMap.get(account.Subsidiary__c).Postal_Code_Character_Limit__c))),
                    account.FSA_Mapping__c
                );
            }
        }
    }
     
    static testMethod void updateAccountException1() {
        Province_Time_Zones_Operating_Hours__c setting = new Province_Time_Zones_Operating_Hours__c();
        setting.Name = 'ON';
        setting.Province_Territory_Code__c = 'ON';
        setting.TimeZone__c = 'America/New_York';
        insert setting;
       
        
        Date todaysDate = System.today();
        List<Account> accounts = new List<Account>([SELECT Id, Name, OperatingHoursId, Hygiene_Operating_Hours__c, Chemical_Operating_Hours__c, Life_Safety_Operating_Hours__c, 
                                                    Pest_Control_Operating_Hours__c, ShippingState FROM Account]);
        
        OperatingHours oh = new OperatingHours(
            Name='TestHours', 
            Operating_Hours_Type__c='Territory Operating Hours', 
            TimeZone='America/New_York'
        );
        
        insert oh;
        
        Account a1 = accounts.get(1);
        Account a2 = accounts.get(2);
        
        a1.OperatingHoursId = oh.Id;
        a2.OperatingHoursId = oh.Id;
        a1.Hygiene_Operating_Hours__c = oh.Id;
        a2.Hygiene_Operating_Hours__c = oh.Id;
        a1.Chemical_Operating_Hours__c = oh.Id;
        a2.Chemical_Operating_Hours__c = oh.Id;
        a1.Life_Safety_Operating_Hours__c = oh.Id;
        a2.Life_Safety_Operating_Hours__c = oh.Id;
        a1.Pest_Control_Operating_Hours__c = oh.Id;
        a2.Pest_Control_Operating_Hours__c = oh.Id;
        try {
            update new List<Account>{a1, a2};
                } catch (Exception e) {
            System.assert(e.getMessage().contains('Account Operating Hours'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void updateAccountException2() {
        Province_Time_Zones_Operating_Hours__c setting = new Province_Time_Zones_Operating_Hours__c();
        setting.Name = 'ON';
        setting.Province_Territory_Code__c = 'ON';
        setting.TimeZone__c = 'America/Los_Angeles';
        insert setting;
        
        Date todaysDate = System.today();
        List<Account> accounts = new List<Account>([SELECT Id, Name, OperatingHoursId, Hygiene_Operating_Hours__c, Chemical_Operating_Hours__c, Life_Safety_Operating_Hours__c, 
                                                    Pest_Control_Operating_Hours__c, ShippingState FROM Account]);
       
        OperatingHours oh = new OperatingHours(
            Name='TestHours', 
            Operating_Hours_Type__c='Account Operating Hours', 
            TimeZone='America/New_York'
        );
        
        insert oh;
        
        Account a1 = accounts.get(1);
        Account a2 = accounts.get(2);
        
        a1.ShippingState = 'ON';
        a2.ShippingState = 'ON';
        a1.OperatingHoursId = oh.Id;
        a2.OperatingHoursId = oh.Id;
        a1.Hygiene_Operating_Hours__c = oh.Id;
        a2.Hygiene_Operating_Hours__c = oh.Id;
        a1.Chemical_Operating_Hours__c = oh.Id;
        a2.Chemical_Operating_Hours__c = oh.Id;
        a1.Life_Safety_Operating_Hours__c = oh.Id;
        a2.Life_Safety_Operating_Hours__c = oh.Id;
        a1.Pest_Control_Operating_Hours__c = oh.Id;
        a2.Pest_Control_Operating_Hours__c = oh.Id;
        try {
            update new List<Account>{a1, a2};
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Operating Hours TimeZone'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void updateAccountException3() {
        Province_Time_Zones_Operating_Hours__c setting = new Province_Time_Zones_Operating_Hours__c();
        setting.Name = 'ON';
        setting.Province_Territory_Code__c = 'ON';
        setting.TimeZone__c = 'America/New_York';
        insert setting;
        
        
        Date todaysDate = System.today();
        List<Account> accounts = new List<Account>([SELECT Id, Name, OperatingHoursId, Hygiene_Operating_Hours__c, Chemical_Operating_Hours__c, Life_Safety_Operating_Hours__c, 
                                                    Pest_Control_Operating_Hours__c, ShippingState FROM Account]);
        
        OperatingHours oh = new OperatingHours(
            Name='TestHours', 
            Operating_Hours_Type__c='Account Operating Hours', 
            TimeZone='America/New_York'
        );
        
        insert oh;
        
        Account a1 = accounts.get(1);
        Account a2 = accounts.get(2);
        
        a1.ShippingState = null;
        a2.ShippingState = null;
        a1.OperatingHoursId = oh.Id;
        a2.OperatingHoursId = oh.Id;
        a1.Hygiene_Operating_Hours__c = oh.Id;
        a2.Hygiene_Operating_Hours__c = oh.Id;
        a1.Chemical_Operating_Hours__c = oh.Id;
        a2.Chemical_Operating_Hours__c = oh.Id;
        a1.Life_Safety_Operating_Hours__c = oh.Id;
        a2.Life_Safety_Operating_Hours__c = oh.Id;
        a1.Pest_Control_Operating_Hours__c = oh.Id;
        a2.Pest_Control_Operating_Hours__c = oh.Id;
        //update new List<Account>{a1, a2};
        try {
            update new List<Account>{a1, a2};
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Please complete Shipping'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void updateAccountNoException() {
        Province_Time_Zones_Operating_Hours__c setting = new Province_Time_Zones_Operating_Hours__c();
        setting.Name = 'ON';
        setting.Province_Territory_Code__c = 'ON';
        setting.TimeZone__c = 'America/New_York';
        insert setting;
        
        
        Date todaysDate = System.today();
        List<Account> accounts = new List<Account>([SELECT Id, Name, OperatingHoursId FROM Account]);
        
        OperatingHours oh = new OperatingHours(
            Name='TestHours', 
            Operating_Hours_Type__c='Account Operating Hours', 
            TimeZone='America/New_York'
        );
        
        insert oh;
        
        Account a1 = accounts.get(1);
        Account a2 = accounts.get(2);        
        a1.OperatingHoursId = oh.Id;
        a2.OperatingHoursId = oh.Id;
        update new List<Account>{a1, a2};
    }
    
    static testMethod void updateAccountNoExceptionAddressCheck() {
        Province_Time_Zones_Operating_Hours__c setting = new Province_Time_Zones_Operating_Hours__c();
        setting.Name = 'ON';
        setting.Province_Territory_Code__c = 'ON';
        setting.TimeZone__c = 'America/New_York';
        insert setting;
        
        
        Date todaysDate = System.today();
        List<Account> accounts = new List<Account>([SELECT Id, Name, OperatingHoursId FROM Account]);
        
        OperatingHours oh = new OperatingHours(
            Name='TestHours', 
            Operating_Hours_Type__c='Account Operating Hours', 
            TimeZone='America/New_York'
        );
        
        insert oh;
        
        Account a1 = accounts.get(1);
        Account a2 = accounts.get(2);        
        a1.OperatingHoursId = oh.Id;
        a2.OperatingHoursId = oh.Id;
        update new List<Account>{a1, a2};
    }
    
    static testMethod void updateAccountChangeReporting() {
        Date todaysDate = System.today();
        List<Account> accounts = new List<Account>([SELECT Id, Name, OperatingHoursId FROM Account]);
       
        for(Account a : accounts) {
            a.Detailing_Reporting__c = true;
        }
        
        update accounts;
    }
    
    static testMethod void updateAccountInvoiceAddressNoException(){
        String sysAdminProfileId = [SELECT Id FROM Profile WHERE Name ='System Administrator' LIMIT 1].Id;
        String randomProfileId = [SELECT Id, UserType FROM Profile WHERE Id !=:sysAdminProfileId AND UserType != 'PowerCustomerSuccess' LIMIT 1].Id;
        
        Field_Service_Settings__c fssetting = Field_Service_Settings__c.getOrgDefaults();
        Account a = [SELECT Id, ShippingState, BillingStreet, Invoice_Frequency__c, AccPac_Account__c FROM Account LIMIT 1];
        
        a.AccPac_Account__c = null;
        a.Invoice_Frequency__c = 'M - Monthly';
        a.ShippingState = 'ON';
        a.BillingStreet = 'New Street';
        update a;
    }
    
    static testMethod void testAccountOwnerChange() {        
        test.StartTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User dcf = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1]; 
        User u = new User(Alias = 'standt', Email='standarduser1@cannonservices.ca', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@cannonservices.ca', Employee_Number__c = 'ABCD123TEST');
        
        insert u;
        System.runAs(dcf) {
            Account a = [SELECT Id,Name,  ShippingState, BillingStreet, Invoice_Frequency__c, AccPac_Account__c FROM Account LIMIT 1];
            a.OwnerId=dcf.Id;
            update a;
            Opportunity o = new Opportunity(Name=a.Name + ' Opportunity ', 
                                StageName='Presentation', CloseDate=System.today().addMonths(1),
                                AccountId=a.Id, OwnerId=dcf.Id);
            insert o;      
            a.OwnerId = u.Id;
            update a;
            
            //fetch updated version
            Opportunity oUp = [SELECT Id, OwnerId FROM Opportunity WHERE Id=:o.Id];
            System.assertEquals(oUp.OwnerId, u.Id);
            test.StopTest();
        }
    }

    static testMethod void testFSAStampingPositive() {  
        Account resultAccount = [SELECT Id, FSA_Mapping__r.FSA__c FROM Account LIMIT 1];
        System.assertEquals('L3R', resultAccount.FSA_Mapping__r.FSA__c);
    }

    static testMethod void testFSAStampingNegative() {  

        Account resultAccount = [SELECT Id, FSA_Mapping__r.FSA__c FROM Account LIMIT 1];

        resultAccount.ShippingPostalCode = null;
        update resultAccount;
        resultAccount = [SELECT Id, FSA_Mapping__c FROM Account WHERE Id=:resultAccount.Id];
        System.assertEquals(null, resultAccount.FSA_Mapping__c);        
    }    

    static testMethod void testBillingToShipping(){
        TestDataFactory.crtAcctContact(1, 1, 5, false);
        List<Account> accounts = TestDataFactory.accounts;

        Account resultAccount = [SELECT Id, 
                                BillingStreet, 
                                BillingCity, 
                                BillingState, 
                                BillingPostalCode, 
                                BillingCountry,
                                ShippingStreet,
                                ShippingCity,
                                ShippingState,
                                ShippingPostalCode,
                                ShippingCountry 
                        FROM Account 
                        WHERE Id=:accounts[0].Id];

        System.assertEquals(resultAccount.BillingStreet, resultAccount.ShippingStreet); 
        System.assertEquals(resultAccount.BillingCity, resultAccount.ShippingCity); 
        System.assertEquals(resultAccount.BillingState, resultAccount.ShippingState); 
        System.assertEquals(resultAccount.BillingPostalCode, resultAccount.ShippingPostalCode); 
        System.assertEquals(resultAccount.BillingCountry, resultAccount.ShippingCountry); 
    }
}