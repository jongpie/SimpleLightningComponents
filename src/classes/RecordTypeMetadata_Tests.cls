/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class RecordTypeMetadata_Tests {

    private static final String ORG_NAMESPACE_PREFIX;

    static {
        ORG_NAMESPACE_PREFIX = [SELECT NamespacePrefix FROM Organization].NamespacePrefix;
    }

    @isTest
    static void it_should_return_record_type_metadata_for_record_type_info() {
        // For larger orgs with a lot of record types, we don't need to test every record type
        // We'll keep a count and stop after 5 to keep tests quick
        Integer count = 0;

        Schema.SobjectType accountSobjectType = Schema.Account.SobjectType;
        for(Schema.RecordTypeInfo recordTypeInfo : Schema.SobjectType.Account.getRecordTypeInfos()) {
            if(count >= 5) break;

            RecordTypeMetadata recordTypeMetadata = new RecordTypeMetadata(accountSobjectType, recordTypeInfo);
            count++;
        }
    }

    @isTest
    static void it_should_return_record_type_metadata_for_sobject_and_record_type_api_names() {
        for(RecordType recordType : [SELECT Id, BusinessProcessId, Description, DeveloperName, NamespacePrefix, SobjectType FROM RecordType LIMIT 5]) {
            Schema.RecordTypeInfo recordTypeInfo = Schema.getGlobalDescribe().get(recordType.SobjectType).getDescribe().getRecordTypeInfosById().get(recordType.Id);
            String namespace = recordType.NamespacePrefix == null || recordType.NamespacePrefix == ORG_NAMESPACE_PREFIX ? '' : recordType.NamespacePrefix + '__';
            RecordTypeMetadata recordTypeMetadata = new RecordTypeMetadata(recordType.SobjectType, namespace + recordType.DeveloperName);
            validateAttributesAreSet(recordTypeInfo, recordType, recordType.SobjectType, recordTypeMetadata);
            validateCaseSentivityForJavascript(recordTypeMetadata);
        }
    }

    @isTest
    static void it_should_return_record_type_metadata_for_record_type_id() {
        Schema.RecordTypeInfo queryableRecordTypeInfo;
        for(Schema.RecordTypeInfo recordTypeInfo : Schema.SobjectType.Account.getRecordTypeInfos()) {
            if(recordTypeInfo.isMaster()) continue;

            queryableRecordTypeInfo = recordTypeInfo;
            break;
        }

        if(queryableRecordTypeInfo == null) return; // This will be null in orgs with no record types, so the test can't finish

        RecordTypeMetadata recordTypeMetadata = new RecordTypeMetadata(Schema.Account.SobjectType, queryableRecordTypeInfo.getRecordTypeId());
        RecordType recordType = [
            SELECT Id, DeveloperName, NamespacePrefix, SobjectType
            FROM RecordType WHERE Id = :queryableRecordTypeInfo.getRecordTypeId()
        ];
        validateAttributesAreSet(queryableRecordTypeInfo, recordType, recordType.SobjectType, recordTypeMetadata);
        validateCaseSentivityForJavascript(recordTypeMetadata);
    }

    private static void validateAttributesAreSet(RecordTypeInfo recordTypeInfo, RecordType recordType, String sobjectApiName, RecordTypeMetadata recordTypeMetadata) {
        String namespace;
        String namespacePrefix = '';
        if(recordType != null && recordType.NamespacePrefix != null && recordType.NamespacePrefix != ORG_NAMESPACE_PREFIX) {
            namespace = recordType.NamespacePrefix;
            namespacePrefix = recordType.NamespacePrefix + '__';
        }
        String recordTypeName = recordType == null ? null : namespacePrefix + recordType.DeveloperName;

        System.assertEquals(recordType == null ? null : recordTypeName, recordTypeMetadata.ApiName);
        System.assertEquals(recordTypeInfo.getRecordTypeId(), recordTypeMetadata.Id);
        System.assertEquals(recordTypeInfo.isActive(), recordTypeMetadata.IsActive);
        System.assertEquals(recordTypeInfo.isAvailable(), recordTypeMetadata.IsAvailable);
        System.assertEquals(recordTypeInfo.isDefaultRecordTypeMapping(), recordTypeMetadata.IsDefault);
        System.assertEquals(recordTypeInfo.isMaster(), recordTypeMetadata.IsMaster);
        System.assertEquals(recordTypeInfo.getName(), recordTypeMetadata.Label);
        System.assertEquals(recordType == null ? null : recordType.DeveloperName, recordTypeMetadata.LocalApiName);
        System.assertEquals(recordType == null ? null : namespace, recordTypeMetadata.Namespace);
        System.assertEquals(sobjectApiName, recordTypeMetadata.SobjectApiName);
    }

    private static void validateCaseSentivityForJavascript(RecordTypeMetadata recordTypeMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonRecordTypeMetadata = JSON.serialize(recordTypeMetadata);
        Map<String, Object> untypedRecordTypeMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonRecordTypeMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedRecordTypeMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedRecordTypeMetadata.containsKey('ApiName'));
        System.assert(untypedRecordTypeMetadata.containsKey('Id'));
        System.assert(untypedRecordTypeMetadata.containsKey('IsActive'));
        System.assert(untypedRecordTypeMetadata.containsKey('IsAvailable'));
        System.assert(untypedRecordTypeMetadata.containsKey('IsDefault'));
        System.assert(untypedRecordTypeMetadata.containsKey('IsMaster'));
        System.assert(untypedRecordTypeMetadata.containsKey('Label'));
        System.assert(untypedRecordTypeMetadata.containsKey('LocalApiName'));
        System.assert(untypedRecordTypeMetadata.containsKey('Namespace'));
        System.assert(untypedRecordTypeMetadata.containsKey('SobjectApiName'));
    }

}