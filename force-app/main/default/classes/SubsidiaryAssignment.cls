public class SubsidiaryAssignment {
    public static void assignSubsidiary(SObjectType soType, SObject sobj) {
        Id rtId = (Id)sobj.get('RecordTypeId');
        String recordTypeName = soType.getDescribe().getRecordTypeInfosById().get(rtId).getName();
        switch on recordTypeName {
            when 'US' {
                sobj.put('Subsidiary__c', recordTypeName);
            }
            when 'UK' {
                sobj.put('Subsidiary__c', recordTypeName);
            }
            when else {
                sobj.put('Subsidiary__c', 'CA');
            }
        }
    }
}