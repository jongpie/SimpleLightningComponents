/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class EnvironmentMetadata {

    // Some info must be queried from the Organization object, so cache the results to limit query count to 1
    private static Organization organization;

    static {
        organization = [SELECT Id, Name, InstanceName, NamespacePrefix, OrganizationType, IsSandbox FROM Organization LIMIT 1];
    }

    @AuraEnabled global final String baseUrl                       {get; private set;}
    @AuraEnabled global final String instanceName                  {get; private set;}
    @AuraEnabled global final Boolean isChatterEnabled             {get; private set;}
    @AuraEnabled global final Boolean isKnowledgeEnabled           {get; private set;}
    @AuraEnabled global final Boolean isMultiCurrencyEnabled       {get; private set;}
    @AuraEnabled global final Boolean isPersonAccountEnabled       {get; private set;}
    @AuraEnabled global final Boolean isProduction                 {get; private set;}
    @AuraEnabled global final Boolean isSandbox                    {get; private set;}
    @AuraEnabled global final Boolean isTerritoryManagementEnabled {get; private set;}
    @AuraEnabled global final String namespace                     {get; private set;}
    @AuraEnabled global final Id organizationId                    {get; private set;}
    @AuraEnabled global final String organizationName              {get; private set;}
    @AuraEnabled global final String organizationType              {get; private set;}
    @AuraEnabled global final List<String> queueApiNames           {get; private set;}
    @AuraEnabled global final List<String> sobjectApiNames         {get; private set;}

    global EnvironmentMetadata() {
        Map<String, Schema.SObjectType> sobjectTypes = Schema.getGlobalDescribe();

        this.baseUrl                      = Url.getSalesforceBaseUrl().toExternalForm();
        this.instanceName                 = organization.InstanceName;
        this.isChatterEnabled             = sobjectTypes.containsKey('FeedItem');
        this.isKnowledgeEnabled           = sobjectTypes.containsKey('KnowledgeArticle');
        this.isMultiCurrencyEnabled       = UserInfo.isMultiCurrencyOrganization();
        this.isPersonAccountEnabled       = sobjectTypes.get('Account').getDescribe().fields.getMap().containsKey('IsPersonAccount');
        this.isProduction                 = organization.IsSandbox == false;
        this.isSandbox                    = organization.IsSandbox;
        this.isTerritoryManagementEnabled = sobjectTypes.containsKey('Territory');
        this.namespace                    = organization.NamespacePrefix;
        this.organizationId               = organization.Id;
        this.organizationName             = organization.Name;
        this.organizationType             = organization.OrganizationType;
        this.queueApiNames                = QueueMetadata.getQueueApiNames();
        this.sobjectApiNames              = this.getSObjectApiNames(sobjectTypes);
    }

    private List<String> getSObjectApiNames(Map<String, Schema.SObjectType> sobjectTypes) {
        // We could just use this.sobjectApiNames = new List<String>(sobjectTypes.keySet());
        // However, it returns the names in lowercase, which can cause problems with Javascript/Lightning since it's case-sensitive
        List<String> sobjectApiNames  = new List<String>();
        for(Schema.SObjectType sobjectType : sobjectTypes.values()) {
            sobjectApiNames.add(String.valueOf(sobjectType));
        }
        sobjectApiNames.sort();
        return sobjectApiNames;
    }

}