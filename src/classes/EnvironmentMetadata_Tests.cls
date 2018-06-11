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
        new EnvironmentMetadata();
        Integer initialQueryCount = Limits.getQueries();
        // Only the first initialization should use queries, multiple initializations should use cached results
        for(Integer i = 0; i < 10; i++) {
            new EnvironmentMetadata();
        }
        System.assertEquals(initialQueryCount, Limits.getQueries());

        Test.stopTest();
    }

    private static void validateAttributesAreSet(EnvironmentMetadata environmentMetadata) {
        Organization organization = [SELECT Id, Name, InstanceName, NamespacePrefix, OrganizationType, IsSandbox FROM Organization LIMIT 1];
        Map<String, Schema.SobjectType> sobjectTypes = Schema.getGlobalDescribe();

        System.assertEquals(URL.getSalesforceBaseUrl().toExternalForm(), environmentMetadata.BaseUrl);
        System.assertEquals(organization.InstanceName, environmentMetadata.InstanceName);
        System.assertEquals(sobjectTypes.containsKey('FeedItem'), environmentMetadata.IsChatterEnabled);
        System.assertEquals(sobjectTypes.containsKey('KnowledgeArticle'), environmentMetadata.IsKnowledgeEnabled);
        System.assertEquals(UserInfo.isMultiCurrencyOrganization(), environmentMetadata.IsMultiCurrencyEnabled);
        System.assertEquals(sobjectTypes.get('Account').getDescribe().fields.getMap().containsKey('IsPersonAccount'), environmentMetadata.IsPersonAccountEnabled);
        System.assertEquals(organization.IsSandbox == false, environmentMetadata.IsProduction);
        System.assertEquals(organization.IsSandbox, environmentMetadata.IsSandbox);
        System.assertEquals(sobjectTypes.containsKey('Territory'), environmentMetadata.IsTerritoryManagementEnabled);
        System.assertEquals(organization.NamespacePrefix, environmentMetadata.Namespace);
        System.assertEquals(organization.Id, environmentMetadata.OrganizationId);
        System.assertEquals(organization.Name, environmentMetadata.OrganizationName);
        System.assertEquals(organization.OrganizationType, environmentMetadata.OrganizationType);
        //System.assert(environmentMetadata.SobjectTypeNames.containsAll(sobjectTypes.keySet()));
    }

    private static void validateCaseSentivityForJavascript(EnvironmentMetadata environmentMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonEnvironmentMetadata = JSON.serialize(environmentMetadata);
        Map<String, Object> untypedEnvironmentMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonEnvironmentMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedEnvironmentMetadata.containsKey('BASEURL') == false);
        // Now for the 'real' tests
        System.assert(untypedEnvironmentMetadata.containsKey('BaseUrl'));
        System.assert(untypedEnvironmentMetadata.containsKey('InstanceName'));
        System.assert(untypedEnvironmentMetadata.containsKey('IsChatterEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('IsKnowledgeEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('IsMultiCurrencyEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('IsPersonAccountEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('IsProduction'));
        System.assert(untypedEnvironmentMetadata.containsKey('IsSandbox'));
        System.assert(untypedEnvironmentMetadata.containsKey('IsTerritoryManagementEnabled'));
        System.assert(untypedEnvironmentMetadata.containsKey('Namespace'));
        System.assert(untypedEnvironmentMetadata.containsKey('OrganizationId'));
        System.assert(untypedEnvironmentMetadata.containsKey('OrganizationName'));
        System.assert(untypedEnvironmentMetadata.containsKey('OrganizationType'));
        System.assert(untypedEnvironmentMetadata.containsKey('SobjectApiNames'));
    }

}