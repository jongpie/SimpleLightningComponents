/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class SObjectMetadata_Tests {

    @isTest
    static void it_should_return_metadata_for_account_sobject_token() {
        SObjectMetadata accountMetadata = new SObjectMetadata(Schema.Account.SObjectType);
        validateAttributesAreSet(accountMetadata);
        validateCaseSentivityForJavascript(accountMetadata);
    }

    @isTest
    static void it_should_return_metadata_for_account_sobject_api_name() {
        SObjectMetadata accountMetadata = new SObjectMetadata('Account');
        validateAttributesAreSet(accountMetadata);
        validateCaseSentivityForJavascript(accountMetadata);
    }

    private static void validateAttributesAreSet(SObjectMetadata sobjectMetadata) {
        Schema.DescribeSObjectResult accountDescribe = Schema.Account.SObjectType.getDescribe();

        System.assertEquals('Account', sobjectMetadata.apiName);
        System.assertEquals('Name', sobjectMetadata.displayFieldApiName);
        System.assertEquals(accountDescribe.fields.getMap().size(), sobjectMetadata.fieldApiNames.size());
        System.assertEquals(accountDescribe.getHasSubtypes(), sobjectMetadata.hasSubtypes);
        System.assertEquals(accountDescribe.isAccessible(), sobjectMetadata.isAccessible);
        System.assertEquals(accountDescribe.isFeedEnabled(), sobjectMetadata.isChatterFeedEnabled);
        System.assertEquals(accountDescribe.isCreateable(), sobjectMetadata.isCreateable);
        System.assertEquals(accountDescribe.isCustom(), sobjectMetadata.isCustom);
        System.assertEquals(accountDescribe.isCustomSetting(), sobjectMetadata.isCustomSetting);
        System.assertEquals(accountDescribe.isDeletable(), sobjectMetadata.isDeletable);
        System.assertEquals(accountDescribe.isMergeable(), sobjectMetadata.isMergeable);
        System.assertEquals(accountDescribe.isMruEnabled(), sobjectMetadata.isMRUEnabled);
        System.assertEquals(accountDescribe.isQueryable(), sobjectMetadata.isQueryable);
        System.assertEquals(accountDescribe.isSearchable(), sobjectMetadata.isSearchable);
        System.assertEquals(accountDescribe.isUndeletable(), sobjectMetadata.isUndeletable);
        System.assertEquals(accountDescribe.isUpdateable(), sobjectMetadata.isUpdateable);
        System.assertEquals(accountDescribe.getKeyPrefix(), sobjectMetadata.keyPrefix);
        System.assertEquals(accountDescribe.getLabel(), sobjectMetadata.label);
        System.assertEquals(accountDescribe.getLabelPlural(), sobjectMetadata.labelPlural);
        System.assertEquals(accountDescribe.getLocalName(), sobjectMetadata.localApiName);
        System.assertEquals('standard:account', sobjectMetadata.tabIcon);

        System.assertNotEquals(null, sobjectMetadata.apiName);
        System.assertNotEquals(null, sobjectMetadata.displayFieldApiName);
        System.assertNotEquals(null, sobjectMetadata.hasMultiCurrency);
        System.assertNotEquals(null, sobjectMetadata.hasSubtypes);
        System.assertNotEquals(null, sobjectMetadata.isAccessible);
        System.assertNotEquals(null, sobjectMetadata.isChatterFeedEnabled);
        System.assertNotEquals(null, sobjectMetadata.isCreateable);
        System.assertNotEquals(null, sobjectMetadata.isCustom);
        System.assertNotEquals(null, sobjectMetadata.isCustomSetting);
        System.assertNotEquals(null, sobjectMetadata.isDeletable);
        System.assertNotEquals(null, sobjectMetadata.isMruEnabled);
        System.assertNotEquals(null, sobjectMetadata.isMergeable);
        System.assertNotEquals(null, sobjectMetadata.isQueryable);
        System.assertNotEquals(null, sobjectMetadata.isSearchable);
        System.assertNotEquals(null, sobjectMetadata.isUndeletable);
        System.assertNotEquals(null, sobjectMetadata.isUpdateable);
        System.assertNotEquals(null, sobjectMetadata.fieldApiNames);
        System.assertNotEquals(null, sobjectMetadata.fieldSetApiNames);
        System.assertNotEquals(null, sobjectMetadata.keyPrefix);
        System.assertNotEquals(null, sobjectMetadata.label);
        System.assertNotEquals(null, sobjectMetadata.labelPlural);
        System.assertNotEquals(null, sobjectMetadata.localApiName);
        System.assertNotEquals(null, sobjectMetadata.tabIcon);
    }

    private static void validateCaseSentivityForJavascript(SObjectMetadata sobjectMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonSObjectMetadata = JSON.serialize(sobjectMetadata);
        Map<String, Object> untypedSObjectMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonSObjectMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedSObjectMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedSObjectMetadata.containsKey('apiName'));
        System.assert(untypedSObjectMetadata.containsKey('displayFieldApiName'));
        System.assert(untypedSObjectMetadata.containsKey('hasMultiCurrency'));
        System.assert(untypedSObjectMetadata.containsKey('hasSubtypes'));
        System.assert(untypedSObjectMetadata.containsKey('isAccessible'));
        System.assert(untypedSObjectMetadata.containsKey('isChatterFeedEnabled'));
        System.assert(untypedSObjectMetadata.containsKey('isCreateable'));
        System.assert(untypedSObjectMetadata.containsKey('isCustom'));
        System.assert(untypedSObjectMetadata.containsKey('isCustomSetting'));
        System.assert(untypedSObjectMetadata.containsKey('isDeletable'));
        System.assert(untypedSObjectMetadata.containsKey('isMruEnabled'));
        System.assert(untypedSObjectMetadata.containsKey('isMergeable'));
        System.assert(untypedSObjectMetadata.containsKey('isQueryable'));
        System.assert(untypedSObjectMetadata.containsKey('isSearchable'));
        System.assert(untypedSObjectMetadata.containsKey('isUndeletable'));
        System.assert(untypedSObjectMetadata.containsKey('isUpdateable'));
        System.assert(untypedSObjectMetadata.containsKey('fieldApiNames'));
        System.assert(untypedSObjectMetadata.containsKey('fieldSetApiNames'));
        System.assert(untypedSObjectMetadata.containsKey('keyPrefix'));
        System.assert(untypedSObjectMetadata.containsKey('label'));
        System.assert(untypedSObjectMetadata.containsKey('labelPlural'));
        System.assert(untypedSObjectMetadata.containsKey('listViewApiNames'));
        System.assert(untypedSObjectMetadata.containsKey('localApiName'));
        System.assert(untypedSObjectMetadata.containsKey('namespace'));
        System.assert(untypedSObjectMetadata.containsKey('recordTypeApiNames'));
        System.assert(untypedSObjectMetadata.containsKey('tabIcon'));
    }

}