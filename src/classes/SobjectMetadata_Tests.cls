/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class SobjectMetadata_Tests {

    @isTest
    static void it_should_return_metadata_for_account_sobject_token() {
        SobjectMetadata accountMetadata = new SobjectMetadata(Schema.Account.SobjectType);
        validateAttributesAreSet(accountMetadata);
        validateCaseSentivityForJavascript(accountMetadata);
    }

    @isTest
    static void it_should_return_metadata_for_account_sobject_api_name() {
        SobjectMetadata accountMetadata = new SobjectMetadata('Account');
        validateAttributesAreSet(accountMetadata);
        validateCaseSentivityForJavascript(accountMetadata);
    }

    private static void validateAttributesAreSet(SobjectMetadata sobjectMetadata) {
        Schema.DescribeSobjectResult accountDescribe = Schema.Account.SobjectType.getDescribe();

        System.assertEquals('Account', sobjectMetadata.ApiName);
        System.assertEquals('Name', sobjectMetadata.DisplayFieldApiName);
        System.assertEquals(accountDescribe.getChildRelationships().size(), sobjectMetadata.ChildRelationships.size());
        System.assertEquals(accountDescribe.fields.getMap().size(), sobjectMetadata.FieldApiNames.size());
        System.assertEquals(accountDescribe.getHasSubtypes(), sobjectMetadata.HasSubtypes);
        System.assertEquals(accountDescribe.isAccessible(), sobjectMetadata.IsAccessible);
        System.assertEquals(accountDescribe.isFeedEnabled(), sobjectMetadata.IsChatterFeedEnabled);
        System.assertEquals(accountDescribe.isCreateable(), sobjectMetadata.IsCreateable);
        System.assertEquals(accountDescribe.isCustom(), sobjectMetadata.IsCustom);
        System.assertEquals(accountDescribe.isCustomSetting(), sobjectMetadata.IsCustomSetting);
        System.assertEquals(accountDescribe.isDeletable(), sobjectMetadata.IsDeletable);
        System.assertEquals(accountDescribe.isMergeable(), sobjectMetadata.IsMergeable);
        System.assertEquals(accountDescribe.isMruEnabled(), sobjectMetadata.IsMRUEnabled);
        System.assertEquals(accountDescribe.isQueryable(), sobjectMetadata.IsQueryable);
        System.assertEquals(accountDescribe.isSearchable(), sobjectMetadata.IsSearchable);
        System.assertEquals(accountDescribe.isUndeletable(), sobjectMetadata.IsUndeletable);
        System.assertEquals(accountDescribe.isUpdateable(), sobjectMetadata.IsUpdateable);
        System.assertEquals(accountDescribe.getKeyPrefix(), sobjectMetadata.KeyPrefix);
        System.assertEquals(accountDescribe.getLabel(), sobjectMetadata.Label);
        System.assertEquals(accountDescribe.getLabelPlural(), sobjectMetadata.LabelPlural);
        System.assertEquals(accountDescribe.getLocalName(), sobjectMetadata.LocalApiName);
        System.assertEquals(accountDescribe.getRecordTypeInfos().size(), sobjectMetadata.RecordTypes.size());
        System.assertEquals('standard:account', sobjectMetadata.TabIcon);

        System.assertNotEquals(null, sobjectMetadata.ApiName);
        System.assertNotEquals(null, sobjectMetadata.ChildRelationships);
        System.assertNotEquals(null, sobjectMetadata.DisplayFieldApiName);
        System.assertNotEquals(null, sobjectMetadata.HasMultiCurrency);
        System.assertNotEquals(null, sobjectMetadata.HasSubtypes);
        System.assertNotEquals(null, sobjectMetadata.IsAccessible);
        System.assertNotEquals(null, sobjectMetadata.IsChatterFeedEnabled);
        System.assertNotEquals(null, sobjectMetadata.IsCreateable);
        System.assertNotEquals(null, sobjectMetadata.IsCustom);
        System.assertNotEquals(null, sobjectMetadata.IsCustomSetting);
        System.assertNotEquals(null, sobjectMetadata.IsDeletable);
        System.assertNotEquals(null, sobjectMetadata.IsMruEnabled);
        System.assertNotEquals(null, sobjectMetadata.IsMergeable);
        System.assertNotEquals(null, sobjectMetadata.IsQueryable);
        System.assertNotEquals(null, sobjectMetadata.IsSearchable);
        System.assertNotEquals(null, sobjectMetadata.IsUndeletable);
        System.assertNotEquals(null, sobjectMetadata.IsUpdateable);
        System.assertNotEquals(null, sobjectMetadata.FieldApiNames);
        System.assertNotEquals(null, sobjectMetadata.FieldSetApiNames);
        System.assertNotEquals(null, sobjectMetadata.KeyPrefix);
        System.assertNotEquals(null, sobjectMetadata.Label);
        System.assertNotEquals(null, sobjectMetadata.LabelPlural);
        System.assertNotEquals(null, sobjectMetadata.LocalApiName);
        System.assertNotEquals(null, sobjectMetadata.RecordTypes);
        System.assertNotEquals(null, sobjectMetadata.TabIcon);
    }

    private static void validateCaseSentivityForJavascript(SobjectMetadata sobjectMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonSobjectMetadata = JSON.serialize(sobjectMetadata);
        Map<String, Object> untypedSobjectMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonSobjectMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedSobjectMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedSobjectMetadata.containsKey('ApiName'));
        System.assert(untypedSobjectMetadata.containsKey('ChildRelationships'));
        System.assert(untypedSobjectMetadata.containsKey('DisplayFieldApiName'));
        System.assert(untypedSobjectMetadata.containsKey('FieldApiNames'));
        System.assert(untypedSobjectMetadata.containsKey('FieldSetApiNames'));
        System.assert(untypedSobjectMetadata.containsKey('HasMultiCurrency'));
        System.assert(untypedSobjectMetadata.containsKey('HasSubtypes'));
        System.assert(untypedSobjectMetadata.containsKey('IsAccessible'));
        System.assert(untypedSobjectMetadata.containsKey('IsChatterFeedEnabled'));
        System.assert(untypedSobjectMetadata.containsKey('IsCreateable'));
        System.assert(untypedSobjectMetadata.containsKey('IsCustom'));
        System.assert(untypedSobjectMetadata.containsKey('IsCustomSetting'));
        System.assert(untypedSobjectMetadata.containsKey('IsDeletable'));
        System.assert(untypedSobjectMetadata.containsKey('IsMruEnabled'));
        System.assert(untypedSobjectMetadata.containsKey('IsMergeable'));
        System.assert(untypedSobjectMetadata.containsKey('IsQueryable'));
        System.assert(untypedSobjectMetadata.containsKey('IsSearchable'));
        System.assert(untypedSobjectMetadata.containsKey('IsUndeletable'));
        System.assert(untypedSobjectMetadata.containsKey('IsUpdateable'));
        System.assert(untypedSobjectMetadata.containsKey('KeyPrefix'));
        System.assert(untypedSobjectMetadata.containsKey('Label'));
        System.assert(untypedSobjectMetadata.containsKey('LabelPlural'));
        System.assert(untypedSobjectMetadata.containsKey('LocalApiName'));
        System.assert(untypedSobjectMetadata.containsKey('Namespace'));
        System.assert(untypedSobjectMetadata.containsKey('RecordTypes'));
        System.assert(untypedSobjectMetadata.containsKey('TabIcon'));
    }

}