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
        SobjectType accountSobjectType = Account.SobjectType;
        SobjectField accountNameField = Account.Name;

        Test.startTest();

        FieldMetadata accountFieldMetadata = new FieldMetadata(accountSobjectType, accountNameField);
        validateAttributesAreSet(String.valueOf(accountNameField), accountFieldMetadata);
        validateCaseSentivityForJavascript(accountFieldMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_account_parentid_lookup_field_token() {
        SobjectField parentIdField = Account.ParentId;

        Test.startTest();

        FieldMetadata accountFieldMetadata = new FieldMetadata(Account.SobjectType, parentIdField);
        validateAttributesAreSet(String.valueOf(parentIdField), accountFieldMetadata);
        validateCaseSentivityForJavascript(accountFieldMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_account_type_picklist_field_token() {
        SobjectField typeField = Account.Type;

        Test.startTest();

        FieldMetadata accountFieldMetadata = new FieldMetadata(Account.SobjectType, typeField);
        validateAttributesAreSet(String.valueOf(typeField), accountFieldMetadata);
        validateCaseSentivityForJavascript(accountFieldMetadata);

        Test.stopTest();
    }

    private static void validateAttributesAreSet(String fieldName, FieldMetadata fieldMetadata) {
        String sobjectName = 'Account';
        DescribeFieldResult fieldDescribe = Schema.SobjectType.Account.fields.getMap().get(fieldName).getDescribe();

        System.assertEquals(fieldDescribe.getName(), fieldMetadata.ApiName);
        System.assertEquals(fieldDescribe.getByteLength(), fieldMetadata.ByteLength);
        System.assertEquals(fieldDescribe.getDefaultValue(), fieldMetadata.DefaultValue);
        System.assertEquals(fieldDescribe.getDigits(), fieldMetadata.Digits);
        System.assertEquals(fieldDescribe.getType().name(), fieldMetadata.DisplayType);
        System.assertEquals(fieldDescribe.getInlineHelpText(), fieldMetadata.InlineHelpText);
        System.assertEquals(fieldDescribe.isAccessible(), fieldMetadata.IsAccessible);
        System.assertEquals(fieldDescribe.isAutoNumber(), fieldMetadata.IsAutoNumber);
        System.assertEquals(fieldDescribe.isCalculated(), fieldMetadata.IsCalculated);
        System.assertEquals(fieldDescribe.isCaseSensitive(), fieldMetadata.IsCaseSensitive);
        System.assertEquals(fieldDescribe.isCreateable(), fieldMetadata.IsCreateable);
        System.assertEquals(fieldDescribe.isCustom(), fieldMetadata.IsCustom);
        System.assertEquals(fieldDescribe.isDefaultedOnCreate(), fieldMetadata.IsDefaultedOnCreate);
        System.assertEquals(fieldDescribe.isFilterable(), fieldMetadata.IsFilterable);
        System.assertEquals(fieldDescribe.isGroupable(), fieldMetadata.IsGroupable);
        System.assertEquals(fieldDescribe.isNameField(), fieldMetadata.IsNameField);
        System.assertEquals(fieldDescribe.isNillable(), fieldMetadata.IsNillable);
        System.assertEquals(fieldDescribe.isNillable() == false && fieldDescribe.isCreateable(), fieldMetadata.IsRequired);
        System.assertEquals(fieldDescribe.isSortable(), fieldMetadata.IsSortable);
        System.assertEquals(fieldDescribe.isUpdateable(), fieldMetadata.IsUpdateable);
        System.assertEquals(fieldDescribe.getLabel(), fieldMetadata.Label);
        System.assertEquals(fieldDescribe.getLocalName(), fieldMetadata.LocalApiName);
        System.assertEquals(fieldDescribe.getLength(), fieldMetadata.MaxLength);
        //System.assertEquals(this.getNamespace(), fieldMetadata.namespace);
        //System.assertEquals(this.getPicklistOptions(fieldDescribe), fieldMetadata.picklistOptions);
        System.assertEquals(fieldDescribe.getPrecision(), fieldMetadata.Precision);
        System.assertEquals(fieldDescribe.getRelationshipName(), fieldMetadata.RelationshipApiName);
        System.assertEquals(fieldDescribe.getRelationshipOrder(), fieldMetadata.RelationshipOrder);
        //System.assertEquals( this.getRelationshipReferences(fieldDescribe), fieldMetadata.RelationshipReferences);
        System.assertEquals(fieldDescribe.getScale(), fieldMetadata.Scale);
        System.assertEquals(sobjectName, fieldMetadata.SobjectApiName);
    }

    private static void validateCaseSentivityForJavascript(FieldMetadata fieldMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonFieldMetadata = JSON.serialize(fieldMetadata);
        Map<String, Object> untypedFieldMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonFieldMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedFieldMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedFieldMetadata.containsKey('ApiName'));
        System.assert(untypedFieldMetadata.containsKey('ByteLength'));
        System.assert(untypedFieldMetadata.containsKey('DefaultValue'));
        System.assert(untypedFieldMetadata.containsKey('Digits'));
        System.assert(untypedFieldMetadata.containsKey('DisplayType'));
        System.assert(untypedFieldMetadata.containsKey('InlineHelpText'));
        System.assert(untypedFieldMetadata.containsKey('IsAccessible'));
        System.assert(untypedFieldMetadata.containsKey('IsAutoNumber'));
        System.assert(untypedFieldMetadata.containsKey('IsCalculated'));
        System.assert(untypedFieldMetadata.containsKey('IsCaseSensitive'));
        System.assert(untypedFieldMetadata.containsKey('IsCreateable'));
        System.assert(untypedFieldMetadata.containsKey('IsCustom'));
        System.assert(untypedFieldMetadata.containsKey('IsDefaultedOnCreate'));
        System.assert(untypedFieldMetadata.containsKey('IsFilterable'));
        System.assert(untypedFieldMetadata.containsKey('IsGroupable'));
        System.assert(untypedFieldMetadata.containsKey('IsNameField'));
        System.assert(untypedFieldMetadata.containsKey('IsNillable'));
        System.assert(untypedFieldMetadata.containsKey('IsRequired'));
        System.assert(untypedFieldMetadata.containsKey('IsSortable'));
        System.assert(untypedFieldMetadata.containsKey('IsUpdateable'));
        System.assert(untypedFieldMetadata.containsKey('Label'));
        System.assert(untypedFieldMetadata.containsKey('LocalApiName'));
        System.assert(untypedFieldMetadata.containsKey('MaxLength'));
        System.assert(untypedFieldMetadata.containsKey('Namespace'));
        System.assert(untypedFieldMetadata.containsKey('PicklistOptions'));
        System.assert(untypedFieldMetadata.containsKey('Precision'));
        System.assert(untypedFieldMetadata.containsKey('RelationshipApiName'));
        System.assert(untypedFieldMetadata.containsKey('RelationshipOrder'));
        System.assert(untypedFieldMetadata.containsKey('RelationshipReferences'));
        System.assert(untypedFieldMetadata.containsKey('Scale'));
        System.assert(untypedFieldMetadata.containsKey('SobjectApiName'));
    }

}