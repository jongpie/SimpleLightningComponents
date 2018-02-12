/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class FieldMetadata_Tests {

    @isTest
    static void it_should_return_metadata_for_sobject_name_and_field_api_name() {
        String sobjectname = 'Account';
        String fieldName = 'Name';

        Test.startTest();

        FieldMetadata accountFieldMetadata = new FieldMetadata(sobjectName, fieldName);
        validateAttributesAreSet(String.valueOf(fieldName), accountFieldMetadata);
        validateCaseSentivityForJavascript(accountFieldMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_sobject_type_token_and_field_token() {
        SObjectType accountSObjectType = Account.SObjectType;
        SObjectField accountNameField = Account.Name;

        Test.startTest();

        FieldMetadata accountFieldMetadata = new FieldMetadata(accountSObjectType, accountNameField);
        validateAttributesAreSet(String.valueOf(accountNameField), accountFieldMetadata);
        validateCaseSentivityForJavascript(accountFieldMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_account_parentid_lookup_field_token() {
        SObjectField parentIdField = Account.ParentId;

        Test.startTest();

        FieldMetadata accountFieldMetadata = new FieldMetadata(Account.SObjectType, parentIdField);
        validateAttributesAreSet(String.valueOf(parentIdField), accountFieldMetadata);
        validateCaseSentivityForJavascript(accountFieldMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_account_type_picklist_field_token() {
        SObjectField typeField = Account.Type;

        Test.startTest();

        FieldMetadata accountFieldMetadata = new FieldMetadata(Account.SObjectType, typeField);
        validateAttributesAreSet(String.valueOf(typeField), accountFieldMetadata);
        validateCaseSentivityForJavascript(accountFieldMetadata);

        Test.stopTest();
    }

    private static void validateAttributesAreSet(String fieldName, FieldMetadata fieldMetadata) {
        String sobjectName = 'Account';
        DescribeFieldResult fieldDescribe = Schema.SObjectType.Account.fields.getMap().get(fieldName).getDescribe();

        System.assertEquals(fieldDescribe.getName(), fieldMetadata.apiName);
        System.assertEquals(fieldDescribe.getByteLength(), fieldMetadata.byteLength);
        System.assertEquals(fieldDescribe.getDefaultValue(), fieldMetadata.defaultValue);
        System.assertEquals(fieldDescribe.getDigits(), fieldMetadata.digits);
        System.assertEquals(fieldDescribe.getType().name(), fieldMetadata.displayType);
        System.assertEquals(fieldDescribe.getInlineHelpText(), fieldMetadata.inlineHelpText);
        System.assertEquals(fieldDescribe.isAccessible(), fieldMetadata.isAccessible);
        System.assertEquals(fieldDescribe.isAutoNumber(), fieldMetadata.isAutoNumber);
        System.assertEquals(fieldDescribe.isCalculated(), fieldMetadata.isCalculated);
        System.assertEquals(fieldDescribe.isCaseSensitive(), fieldMetadata.isCaseSensitive);
        System.assertEquals(fieldDescribe.isCreateable(), fieldMetadata.isCreateable);
        System.assertEquals(fieldDescribe.isCustom(), fieldMetadata.isCustom);
        System.assertEquals(fieldDescribe.isDefaultedOnCreate(), fieldMetadata.isDefaultedOnCreate);
        System.assertEquals(fieldDescribe.isFilterable(), fieldMetadata.isFilterable);
        System.assertEquals(fieldDescribe.isGroupable(), fieldMetadata.isGroupable);
        System.assertEquals(fieldDescribe.isNameField(), fieldMetadata.isNameField);
        System.assertEquals(fieldDescribe.isNillable(), fieldMetadata.isNillable);
        System.assertEquals(fieldDescribe.isNillable() == false && fieldDescribe.isCreateable(), fieldMetadata.isRequired);
        System.assertEquals(fieldDescribe.isSortable(), fieldMetadata.isSortable);
        System.assertEquals(fieldDescribe.isUpdateable(), fieldMetadata.isUpdateable);
        System.assertEquals(fieldDescribe.getLabel(), fieldMetadata.label);
        System.assertEquals(fieldDescribe.getLocalName(), fieldMetadata.localApiName);
        System.assertEquals(fieldDescribe.getLength(), fieldMetadata.maxLength);
        //System.assertEquals(this.getNamespace(), fieldMetadata.namespace);
        //System.assertEquals(this.getPicklistOptions(fieldDescribe), fieldMetadata.picklistOptions);
        System.assertEquals(fieldDescribe.getPrecision(), fieldMetadata.precision);
        System.assertEquals(fieldDescribe.getRelationshipName(), fieldMetadata.relationshipName);
        System.assertEquals(fieldDescribe.getRelationshipOrder(), fieldMetadata.relationshipOrder);
        //System.assertEquals( this.getRelationshipReferences(fieldDescribe), fieldMetadata.relationshipReferences);
        System.assertEquals(fieldDescribe.getScale(), fieldMetadata.scale);
        System.assertEquals(fieldDescribe.getScale(), fieldMetadata.scale);
        System.assertEquals(fieldDescribe.getSOAPType().name(), fieldMetadata.soapType);
        System.assertEquals(sobjectName, fieldMetadata.sobjectApiName);
    }

    private static void validateCaseSentivityForJavascript(FieldMetadata fieldMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonFieldMetadata = JSON.serialize(fieldMetadata);
        Map<String, Object> untypedFieldMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonFieldMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedFieldMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedFieldMetadata.containsKey('apiName'));
        System.assert(untypedFieldMetadata.containsKey('byteLength'));
        System.assert(untypedFieldMetadata.containsKey('defaultValue'));
        System.assert(untypedFieldMetadata.containsKey('digits'));
        System.assert(untypedFieldMetadata.containsKey('displayType'));
        System.assert(untypedFieldMetadata.containsKey('inlineHelpText'));
        System.assert(untypedFieldMetadata.containsKey('isAccessible'));
        System.assert(untypedFieldMetadata.containsKey('isAutoNumber'));
        System.assert(untypedFieldMetadata.containsKey('isCalculated'));
        System.assert(untypedFieldMetadata.containsKey('isCaseSensitive'));
        System.assert(untypedFieldMetadata.containsKey('isCreateable'));
        System.assert(untypedFieldMetadata.containsKey('isCustom'));
        System.assert(untypedFieldMetadata.containsKey('isDefaultedOnCreate'));
        System.assert(untypedFieldMetadata.containsKey('isFilterable'));
        System.assert(untypedFieldMetadata.containsKey('isGroupable'));
        System.assert(untypedFieldMetadata.containsKey('isNameField'));
        System.assert(untypedFieldMetadata.containsKey('isNillable'));
        System.assert(untypedFieldMetadata.containsKey('isRequired'));
        System.assert(untypedFieldMetadata.containsKey('isSortable'));
        System.assert(untypedFieldMetadata.containsKey('isUpdateable'));
        System.assert(untypedFieldMetadata.containsKey('label'));
        System.assert(untypedFieldMetadata.containsKey('localApiName'));
        System.assert(untypedFieldMetadata.containsKey('maxLength'));
        System.assert(untypedFieldMetadata.containsKey('namespace'));
        System.assert(untypedFieldMetadata.containsKey('picklistOptions'));
        System.assert(untypedFieldMetadata.containsKey('precision'));
        System.assert(untypedFieldMetadata.containsKey('relationshipName'));
        System.assert(untypedFieldMetadata.containsKey('relationshipOrder'));
        System.assert(untypedFieldMetadata.containsKey('relationshipReferences'));
        System.assert(untypedFieldMetadata.containsKey('scale'));
        System.assert(untypedFieldMetadata.containsKey('soapType'));
        System.assert(untypedFieldMetadata.containsKey('sobjectApiName'));
    }

}