/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class FieldSetMetadata_Tests {

    @isTest
    static void it_should_return_metadata_for_sobject_api_name_and_field_set_api_name() {
        Schema.FieldSet fieldSet = getFieldSet();
        if(fieldSet == null) return;

        Test.startTest();

        String sobjectName = String.valueOf(fieldSet.getSobjectType());
        String fieldSetNamespace = fieldSet.getNamespace() == null ? '' : fieldSet.getNamespace() + '__';
        String fieldSetName = fieldSetNamespace + fieldSet.getName();
        FieldSetMetadata fieldSetMetadata = new FieldSetMetadata(sobjectName, fieldSetName);
        validateAttributesAreSet(fieldSet, fieldSetMetadata);
        validateCaseSentivityForJavascript(fieldSetMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_field_set_token() {
        Schema.FieldSet fieldSet = getFieldSet();
        if(fieldSet == null) return;

        Test.startTest();

        FieldSetMetadata fieldSetMetadata = new FieldSetMetadata(fieldSet);
        validateAttributesAreSet(fieldSet, fieldSetMetadata);
        validateCaseSentivityForJavascript(fieldSetMetadata);

        Test.stopTest();
    }

    private static Schema.FieldSet getFieldSet() {
        // Dynamically check for field sets in some of the most commonly used objects
        // If not results are found, then test coverage will drop
        List<String> commonSobjectNames = new List<String>{
            'Account', 'Lead', 'Contact', 'Opportunity'
        };
        for(String sobjectName : commonSobjectNames) {
            Schema.DescribeSobjectResult sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();
            // If there are any fields sets found, return the first one
            if(sobjectDescribe.fieldSets.getMap().isEmpty() == false) return sobjectDescribe.fieldSets.getMap().values()[0];
        }
        return null;
    }

    private static void validateAttributesAreSet(Schema.FieldSet fieldSet, FieldSetMetadata fieldSetMetadata) {
        String namespacePrefix = '';
        if(fieldSet.getNamespace() != null) namespacePrefix = fieldSet.getNamespace() + '__';
        String fieldSetName = namespacePrefix + fieldSet.getName();

        System.assertEquals(fieldSetName, fieldSetMetadata.ApiName);
        System.assertEquals(fieldSet.getDescription(), fieldSetMetadata.Description);
        System.assertEquals(fieldSet.getFields().size(), fieldSetMetadata.FieldSetMembers.size());
        // TODO add asserts for field set members' field metadata
        System.assertEquals(fieldSet.getLabel(), fieldSetMetadata.Label);
        // TODO add assert for localName
        System.assertEquals(fieldSet.getNamespace(), fieldSetMetadata.Namespace);
        System.assertEquals(String.valueOf(fieldSet.getSobjectType()), fieldSetMetadata.SobjectApiName);
    }

    private static void validateCaseSentivityForJavascript(FieldSetMetadata fieldSetMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonFieldSetMetadata = JSON.serialize(fieldSetMetadata);
        Map<String, Object> untypedFieldSetMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonFieldSetMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedFieldSetMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedFieldSetMetadata.containsKey('ApiName'));
        System.assert(untypedFieldSetMetadata.containsKey('Description'));
        System.assert(untypedFieldSetMetadata.containsKey('FieldSetMembers'));
        System.assert(untypedFieldSetMetadata.containsKey('Label'));
        System.assert(untypedFieldSetMetadata.containsKey('LocalApiName'));
        System.assert(untypedFieldSetMetadata.containsKey('Namespace'));
        System.assert(untypedFieldSetMetadata.containsKey('SobjectApiName'));
        // TODO add asserts for FieldSetMembers
    }

}