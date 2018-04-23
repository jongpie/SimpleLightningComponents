/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class EnvironmentMetadata_Tests {

    @isTest
    static void it_should_return_environment_metadata() {
        Test.startTest();

        EnvironmentMetadata environmentMetadata = new EnvironmentMetadata();
        validateAttributesAreSet(environmentMetadata);
        validateCaseSentivityForJavascript(environmentMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_cache_organization_object_query() {
        Test.startTest();

        System.assertEquals(0, Limits.getQueries());
        // Only the first initialization should use a query, multiple initializations should use cached results
        for(Integer i = 0; i < 10; i++) {
            new EnvironmentMetadata();
        }
        System.assertEquals(1, Limits.getQueries());

        Test.stopTest();
    }

    private static void validateAttributesAreSet(EnvironmentMetadata environmentMetadata) {
        Organization organization = [SELECT Id, Name, InstanceName, NamespacePrefix, OrganizationType, IsSandbox FROM Organization LIMIT 1];
        Map<String, Schema.SObjectType> sobjectTypes = Schema.getGlobalDescribe();

        System.assertEquals(URL.getSalesforceBaseUrl().toExternalForm(), environmentMetadata.baseUrl);
        System.assertEquals(organization.InstanceName, environmentMetadata.instanceName);
        System.assertEquals(sobjectTypes.containsKey('FeedItem'), environmentMetadata.isChatterEnabled);
        System.assertEquals(sobjectTypes.containsKey('KnowledgeArticle'), environmentMetadata.isKnowledgeEnabled);
        System.assertEquals(UserInfo.isMultiCurrencyOrganization(), environmentMetadata.isMultiCurrencyEnabled);
        System.assertEquals(sobjectTypes.get('Account').getDescribe().fields.getMap().containsKey('IsPersonAccount'), environmentMetadata.isPersonAccountEnabled);
        System.assertEquals(organization.IsSandbox == false, environmentMetadata.isProduction);
        System.assertEquals(organization.IsSandbox, environmentMetadata.isSandbox);
        System.assertEquals(sobjectTypes.containsKey('Territory'), environmentMetadata.isTerritoryManagementEnabled);
        System.assertEquals(organization.NamespacePrefix, environmentMetadata.namespace);
        System.assertEquals(organization.Id, environmentMetadata.organizationId);
        System.assertEquals(organization.Name, environmentMetadata.organizationName);
        System.assertEquals(organization.OrganizationType, environmentMetadata.organizationType);
        //System.assert(environmentMetadata.sobjectTypeNames.containsAll(sobjectTypes.keySet()));
    }

    private static void validateCaseSentivityForJavascript(EnvironmentMetadata environmentMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonEnvironmentMetadata = JSON.serialize(environmentMetadata);
        Map<String, Object> untypedEnvironmentMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonEnvironmentMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedEnvironmentMetadata.containsKey('BASEURL') == false);
        // Now for the 'real' tests
        System.assert(untypedEnvironmentMetadata.containsKey('baseUrl'));
        System.assert(untypedEnvironmentMetadata.containsKey('instanceName'));
        System.assert(untypedEnvironmentMetadata.containsKey('isChatterEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('isKnowledgeEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('isMultiCurrencyEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('isPersonAccountEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('isProduction'));
        System.assert(untypedEnvironmentMetadata.containsKey('isSandbox'));
        System.assert(untypedEnvironmentMetadata.containsKey('isTerritoryManagementEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('namespace'));
        System.assert(untypedEnvironmentMetadata.containsKey('organizationId'));
        System.assert(untypedEnvironmentMetadata.containsKey('organizationName'));
        System.assert(untypedEnvironmentMetadata.containsKey('organizationType'));
        System.assert(untypedEnvironmentMetadata.containsKey('sobjectApiNames'));
    }

}