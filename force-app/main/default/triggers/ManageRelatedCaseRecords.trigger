trigger ManageRelatedCaseRecords on Case (after insert, after update) {
    Field_Service_Settings__c custSetting = Field_Service_Settings__c.getOrgDefaults();
    
    Map<Id,Account> accMap = new Map<Id,Account>();
    List<Account> accUpdates = new List<Account>();
    List<Opportunity> opUpdates = new List<Opportunity>();
    List<Site_Survey__c> ssUpdates = new List<Site_Survey__c>();
    Map<Id,RecordType> rtMap = new Map<Id,RecordType>();
    Id creditCheckTypeId;
    Id dataReviewTypeId;
    Map<Id,String> rejectedOppCase = new Map<Id,String>();
    
    
    for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Case' AND IsActive=TRUE]) {
        rtMap.put(rt.Id, rt);
        if (rt.DeveloperName == 'Internal_Data_Review') {
            dataReviewTypeId = rt.Id;
        }
    }
    
    for (Case c : Trigger.new) {
        if(c.Subsidiary__c == 'CA') {
            Case oldRec = (Trigger.isInsert ? new Case() : Trigger.oldMap.get(c.Id));
            
            Boolean process = Trigger.IsUpdate ? Trigger.OldMap.get(c.Id).Status!= c.Status : true;
            //02/27/2020: Varun Changes for 3rd RT. Opportunity to be changed to Closed: site survey rejected for 3rd recordtype on rejection of ticket
            if(c.Status == custSetting.Site_Survey_Case_Rejected_Status__c && c.RecordTypeId == dataReviewTypeId && process && c.Opportunity__c!=null){
                opUpdates.add(new Opportunity(
                    Id = c.Opportunity__c,
                    StageName = custSetting.Opportunity_Case_Rejection_Stage_Name__c
                ));
                rejectedOppCase.put(c.Opportunity__c,'Your Opportunity: ' +c.caseNumber + ' has been rejected by Customer Success.' + (c.Rejection_Reason_Notes__c!=null? 'Case Rejection Reason: '  + c.Rejection_Reason_Notes__c : '' ));
            }
            System.debug('CASE before the chatter creation block : ' + c);    
        }
    }
    
    if (!opUpdates.isEmpty()) {
        update opUpdates;
    }
    
    if(!rejectedOppCase.isEmpty()){
        for(Opportunity o : [Select Id, OwnerId from Opportunity where id = :rejectedOppCase.keySet()]){
            String caseMessage =  rejectedOppCase.get(o.Id);
            System.debug('NETWORK ID:' + Network.getNetworkId());
            ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), o.Id, '{' + o.ownerId + '} ' + caseMessage);
        }
    }
}