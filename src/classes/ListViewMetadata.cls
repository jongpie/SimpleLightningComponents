/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class ListViewMetadata {

    // Stores cached query results
    private static final Map<Id, ListView> QUERIED_LIST_VIEWS_BY_ID;
    private static final Map<String, ListView> QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME;
    private static final Map<String, List<String>> QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME;

    static {
        // Query & cache queues
        QUERIED_LIST_VIEWS_BY_ID                         = new Map<Id, ListView>();
        QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME = new Map<String, ListView>();
        QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME          = new Map<String, List<String>>();

        for(ListView listView : [SELECT Id, DeveloperName, IsSOQLCompatible, Name, NamespacePrefix, SObjectType FROM ListView]) {
            String namespace = listView.NamespacePrefix == null ? '' : listView.NamespacePrefix + '__';
            QUERIED_LIST_VIEWS_BY_ID.put(listView.Id, listView);
            QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME.put(listView.SObjectType + buildFullyQualifiedName(listView), listView);

            if(!QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.containsKey(listView.SObjectType)) {
                QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.put(listView.SObjectType, new List<String>{});
            }
            List<String> listViewApiNames = QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.get(listView.SObjectType);
            listViewApiNames.add(namespace + listView.DeveloperName);
            QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.put(listView.SObjectType, listViewApiNames);
        }
    }

    public static List<String> getListViewApiNames(String sobjectApiName) {
        List<String> results = QUERIED_LIST_VIEW_NAMES_BY_SOBJECT_NAME.get(sobjectApiName);
        if(results != null) results.sort();
        return results != null ? results : new List<String>();
    }

    // Method is static so it can be used in static methods and instance methods
    private static String buildFullyQualifiedName(ListView listView) {
        return (listView.NamespacePrefix == null ? '' : listView.NamespacePrefix + '__') + listView.DeveloperName;
    }

    @AuraEnabled global final String apiName           {get; private set;}
    @AuraEnabled global final Id id                    {get; private set;}
    @AuraEnabled global final Boolean isSoqlCompatible {get; private set;}
    @AuraEnabled global final String label             {get; private set;}
    @AuraEnabled global final String localApiName      {get; private set;}
    @AuraEnabled global final String namespace         {get; private set;}
    @AuraEnabled global final String sobjectApiName    {get; private set;}

    global ListViewMetadata(String sobjectApiName, String listViewApiName) {
        this(QUERIED_LIST_VIEWS_BY_SOBJECT_AND_DEVELOPER_NAME.get(sobjectApiName + listViewApiName).Id);
    }

    global ListViewMetadata(Id listViewId) {
        ListView listView = QUERIED_LIST_VIEWS_BY_ID.get(listViewId);

        this.apiName          = buildFullyQualifiedName(listView);
        this.id               = listView.Id;
        this.isSoqlCompatible = listView.IsSoqlCompatible;
        this.label            = listView.Name;
        this.localApiName     = listView.DeveloperName;
        this.namespace        = listView.NamespacePrefix;
        this.sobjectApiName   = listView.SObjectType;
    }

}