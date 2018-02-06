/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class ListViewMetadata_Tests {

    @isTest
    static void it_should_return_metadata_for_sobject_api_name_and_list_view_api_name() {
        ListView listView = [SELECT Id, IsSoqlCompatible, Name, DeveloperName, NamespacePrefix, SObjectType FROM ListView LIMIT 1];

        Test.startTest();

        String namespace = listView.NamespacePrefix == null ? '' : listView.NamespacePrefix + '__';
        ListViewMetadata listViewMetadata = new ListViewMetadata(listView.SObjectType, namespace + listView.DeveloperName);
        validateAttributesAreSet(listView, listViewMetadata);
        validateCaseSentivityForJavascript(listViewMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_metadata_for_list_view_id() {
        ListView listView = [SELECT Id, IsSoqlCompatible, Name, DeveloperName, NamespacePrefix, SObjectType FROM ListView LIMIT 1];

        Test.startTest();

        ListViewMetadata listViewMetadata = new ListViewMetadata(listView.Id);
        validateAttributesAreSet(listView, listViewMetadata);
        validateCaseSentivityForJavascript(listViewMetadata);

        Test.stopTest();
    }

    private static void validateAttributesAreSet(ListView listView, ListViewMetadata listViewMetadata) {
        String apiName = (listView.NamespacePrefix == null ? '' : listView.NamespacePrefix + '__') + listView.DeveloperName;

        System.assertEquals(apiName, listViewMetadata.apiName);
        System.assertEquals(listView.Id, listViewMetadata.id);
        System.assertEquals(listView.IsSoqlCompatible, listViewMetadata.isSoqlCompatible);
        System.assertEquals(listView.Name, listViewMetadata.label);
        System.assertEquals(listView.DeveloperName, listViewMetadata.localApiName);
        System.assertEquals(listView.NamespacePrefix, listViewMetadata.namespace);
        System.assertEquals(listView.SObjectType, listViewMetadata.sobjectApiName);
    }

    private static void validateCaseSentivityForJavascript(ListViewMetadata listviewmetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonListViewMetadata = JSON.serialize(listviewmetadata);
        Map<String, Object> untypedListViewMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonListViewMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedListViewMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedListViewMetadata.containsKey('apiName'));
        System.assert(untypedListViewMetadata.containsKey('id'));
        System.assert(untypedListViewMetadata.containsKey('isSoqlCompatible'));
        System.assert(untypedListViewMetadata.containsKey('label'));
        System.assert(untypedListViewMetadata.containsKey('localApiName'));
        System.assert(untypedListViewMetadata.containsKey('namespace'));
        System.assert(untypedListViewMetadata.containsKey('sobjectApiName'));
    }

}