/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class RecordTypeMetadata_Tests {

    @isTest
    static void it_should_return_record_type_metadata_for_record_type_info() {
        // For larger orgs with a lot of record types, we don't need to test every record type
        // We'll keep a count and stop after 5 to keep tests quick
        Integer count = 0;

        Schema.SObjectType accountSObjectType = Schema.Account.SObjectType;
        for(Schema.RecordTypeInfo recordTypeInfo : Schema.SObjectType.Account.getRecordTypeInfos()) {
            if(count >= 5) break;

            RecordTypeMetadata recordTypeMetadata = new RecordTypeMetadata(accountSObjectType, recordTypeInfo);
            count++;
        }
    }

    @isTest
    static void it_should_return_record_type_metadata_for_sobject_and_record_type_api_names() {
        for(RecordType recordType : [SELECT Id, BusinessProcessId, Description, DeveloperName, NamespacePrefix, SObjectType FROM RecordType LIMIT 5]) {
            Schema.RecordTypeInfo recordTypeInfo = Schema.getGlobalDescribe().get(recordType.SObjectType).getDescribe().getRecordTypeInfosById().get(recordType.Id);
            RecordTypeMetadata recordTypeMetadata = new RecordTypeMetadata(recordType.SObjectType, recordType.DeveloperName);
            validateAttributesAreSet(recordTypeInfo, recordType, recordType.SObjectType, recordTypeMetadata);
            validateCaseSentivityForJavascript(recordTypeMetadata);
        }
    }

    @isTest
    static void it_should_return_record_type_metadata_for_record_type_id() {
        Schema.RecordTypeInfo queryableRecordTypeInfo;
        for(Schema.RecordTypeInfo recordTypeInfo : Schema.SObjectType.Account.getRecordTypeInfos()) {
            if(recordTypeInfo.isMaster()) continue;

            queryableRecordTypeInfo = recordTypeInfo;
            break;
        }

        if(queryableRecordTypeInfo == null) return; // This will be null in orgs with no record types, so the test can't finish

        RecordTypeMetadata recordTypeMetadata = new RecordTypeMetadata(queryableRecordTypeInfo.getRecordTypeId());
        RecordType recordType = [
            SELECT Id, BusinessProcessId, Description, DeveloperName, NamespacePrefix, SObjectType
            FROM RecordType WHERE Id = :queryableRecordTypeInfo.getRecordTypeId()
        ];
        validateAttributesAreSet(queryableRecordTypeInfo, recordType, recordType.SObjectType, recordTypeMetadata);
        validateCaseSentivityForJavascript(recordTypeMetadata);
    }

    private static void validateAttributesAreSet(RecordTypeInfo recordTypeInfo, RecordType recordType, String sobjectApiName, RecordTypeMetadata recordTypeMetadata) {
        String namespacePrefix = '';
        if(recordType != null && recordType.NamespacePrefix != null) namespacePrefix = recordType.NamespacePrefix + '__';
        String recordTypeName = recordType == null ? null : namespacePrefix + recordType.DeveloperName;

        System.assertEquals(recordType == null ? null : recordTypeName, recordTypeMetadata.apiName);
        System.assertEquals(recordType == null ? null : recordType.BusinessProcessId, recordTypeMetadata.businessProcessId);
        System.assertEquals(recordType == null ? null : recordType.Description, recordTypeMetadata.description);
        System.assertEquals(recordTypeInfo.getRecordTypeId(), recordTypeMetadata.id);
        System.assertEquals(recordTypeInfo.isActive(), recordTypeMetadata.isActive);
        System.assertEquals(recordTypeInfo.isAvailable(), recordTypeMetadata.isAvailable);
        System.assertEquals(recordTypeInfo.isDefaultRecordTypeMapping(), recordTypeMetadata.isDefault);
        System.assertEquals(recordTypeInfo.isMaster(), recordTypeMetadata.isMaster);
        System.assertEquals(recordTypeInfo.getName(), recordTypeMetadata.label);
        System.assertEquals(recordType == null ? null : recordType.DeveloperName, recordTypeMetadata.localApiName);
        System.assertEquals(recordType == null ? null : recordType.NamespacePrefix, recordTypeMetadata.namespace);
        System.assertEquals(sobjectApiName, recordTypeMetadata.sobjectApiName);
    }

    private static void validateCaseSentivityForJavascript(RecordTypeMetadata recordTypeMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonRecordTypeMetadata = JSON.serialize(recordTypeMetadata);
        Map<String, Object> untypedRecordTypeMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonRecordTypeMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedRecordTypeMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedRecordTypeMetadata.containsKey('apiName'));
        System.assert(untypedRecordTypeMetadata.containsKey('businessProcessId'));
        System.assert(untypedRecordTypeMetadata.containsKey('description'));
        System.assert(untypedRecordTypeMetadata.containsKey('id'));
        System.assert(untypedRecordTypeMetadata.containsKey('isActive'));
        System.assert(untypedRecordTypeMetadata.containsKey('isAvailable'));
        System.assert(untypedRecordTypeMetadata.containsKey('isDefault'));
        System.assert(untypedRecordTypeMetadata.containsKey('isMaster'));
        System.assert(untypedRecordTypeMetadata.containsKey('label'));
        System.assert(untypedRecordTypeMetadata.containsKey('localApiName'));
        System.assert(untypedRecordTypeMetadata.containsKey('namespace'));
        System.assert(untypedRecordTypeMetadata.containsKey('sobjectApiName'));
    }

}