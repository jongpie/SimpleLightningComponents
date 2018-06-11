/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class EnvironmentMetadata {

    // Some info must be queried from the Organization object, so cache the results to limit query count to 1
    private static final Organization ORGANIZATION;

    static {
        ORGANIZATION = [SELECT Id, Name, InstanceName, NamespacePrefix, OrganizationType, IsSandbox FROM Organization LIMIT 1];
    }

    @AuraEnabled global final String BaseUrl                       {get; private set;}
    @AuraEnabled global final String InstanceName                  {get; private set;}
    @AuraEnabled global final Boolean IsChatterEnabled             {get; private set;}
    @AuraEnabled global final Boolean IsKnowledgeEnabled           {get; private set;}
    @AuraEnabled global final Boolean IsMultiCurrencyEnabled       {get; private set;}
    @AuraEnabled global final Boolean IsPersonAccountEnabled       {get; private set;}
    @AuraEnabled global final Boolean IsProduction                 {get; private set;}
    @AuraEnabled global final Boolean IsSandbox                    {get; private set;}
    @AuraEnabled global final Boolean IsTerritoryManagementEnabled {get; private set;}
    @AuraEnabled global final String Namespace                     {get; private set;}
    @AuraEnabled global final Id OrganizationId                    {get; private set;}
    @AuraEnabled global final String OrganizationName              {get; private set;}
    @AuraEnabled global final String OrganizationType              {get; private set;}
    @AuraEnabled global final List<String> QueueApiNames           {get; private set;}
    @AuraEnabled global final List<String> SobjectApiNames         {get; private set;}

    global EnvironmentMetadata() {
        Map<String, Schema.SobjectType> sobjectTypes = Schema.getGlobalDescribe();

        this.BaseUrl                      = Url.getSalesforceBaseUrl().toExternalForm();
        this.InstanceName                 = ORGANIZATION.InstanceName;
        this.IsChatterEnabled             = sobjectTypes.containsKey('FeedItem');
        this.IsKnowledgeEnabled           = sobjectTypes.containsKey('KnowledgeArticle');
        this.IsMultiCurrencyEnabled       = UserInfo.isMultiCurrencyOrganization();
        this.IsPersonAccountEnabled       = sobjectTypes.get('Account').getDescribe().fields.getMap().containsKey('IsPersonAccount');
        this.IsProduction                 = ORGANIZATION.IsSandbox == false;
        this.IsSandbox                    = ORGANIZATION.IsSandbox;
        this.IsTerritoryManagementEnabled = sobjectTypes.containsKey('Territory');
        this.Namespace                    = ORGANIZATION.NamespacePrefix;
        this.OrganizationId               = ORGANIZATION.Id;
        this.OrganizationName             = ORGANIZATION.Name;
        this.OrganizationType             = ORGANIZATION.OrganizationType;
        this.QueueApiNames                = QueueMetadata.getQueueApiNames();
        this.SobjectApiNames              = this.getSobjectApiNames(sobjectTypes);
    }

    private List<String> getSobjectApiNames(Map<String, Schema.SobjectType> sobjectTypes) {
        // We could just use this.sobjectApiNames = new List<String>(sobjectTypes.keySet());
        // However, it returns the names in lowercase, which can cause problems with Javascript/Lightning since it's case-sensitive
        List<String> sobjectApiNames  = new List<String>();
        for(Schema.SobjectType sobjectType : sobjectTypes.values()) {
            sobjectApiNames.add(String.valueOf(sobjectType));
        }
        sobjectApiNames.sort();
        return sobjectApiNames;
    }

}