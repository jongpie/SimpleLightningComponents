/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class SObjectMetadata {

    @AuraEnabled global final String apiName                  {get; private set;}
    @AuraEnabled global final String displayFieldApiName      {get; private set;}
    @AuraEnabled global final Boolean hasMultiCurrency        {get; private set;}
    @AuraEnabled global final Boolean hasSubtypes             {get; private set;}
    @AuraEnabled global final Boolean isAccessible            {get; private set;}
    @AuraEnabled global final Boolean isChatterFeedEnabled    {get; private set;}
    @AuraEnabled global final Boolean isCreateable            {get; private set;}
    @AuraEnabled global final Boolean isCustom                {get; private set;}
    @AuraEnabled global final Boolean isCustomSetting         {get; private set;}
    @AuraEnabled global final Boolean isDeletable             {get; private set;}
    @AuraEnabled global final Boolean isMruEnabled            {get; private set;}
    @AuraEnabled global final Boolean isMergeable             {get; private set;}
    @AuraEnabled global final Boolean isQueryable             {get; private set;}
    @AuraEnabled global final Boolean isSearchable            {get; private set;}
    @AuraEnabled global final Boolean isUndeletable           {get; private set;}
    @AuraEnabled global final Boolean isUpdateable            {get; private set;}
    @AuraEnabled global final List<String> fieldApiNames      {get; private set;}
    @AuraEnabled global final List<String> fieldSetApiNames   {get; private set;}
    @AuraEnabled global final String keyPrefix                {get; private set;}
    @AuraEnabled global final String label                    {get; private set;}
    @AuraEnabled global final String labelPlural              {get; private set;}
    @AuraEnabled global final List<String> listViewApiNames   {get; private set;}
    @AuraEnabled global final String localApiName             {get; private set;}
    @AuraEnabled global final String namespace                {get; private set;}
    @AuraEnabled global final List<String> recordTypeApiNames {get; private set;}
    @AuraEnabled global final String tabIcon                  {get; private set;}

    global SObjectMetadata(String sobjectApiName) {
        this(Schema.getGlobalDescribe().get(sobjectApiName));
    }

    global SObjectMetadata(Schema.SObjectType sobjectType) {
        DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();

        this.apiName              = String.valueOf(sobjectType);
        this.displayFieldApiName  = this.getDisplayFieldApiName(sobjectDescribe);
        this.fieldApiNames        = this.getFieldApiNames(sobjectDescribe);
        this.fieldSetApiNames     = this.getFieldSetApiNames(sobjectDescribe);
        this.hasMultiCurrency     = sobjectDescribe.fields.getMap().containsKey('CurrencyIsoCode');
        this.hasSubtypes          = sobjectDescribe.getHasSubtypes();
        this.isAccessible         = sobjectDescribe.isAccessible();
        this.isChatterFeedEnabled = sobjectDescribe.isFeedEnabled();
        this.isCreateable         = sobjectDescribe.isCreateable();
        this.isCustom             = sobjectDescribe.isCustom();
        this.isCustomSetting      = sobjectDescribe.isCustomSetting();
        this.isDeletable          = sobjectDescribe.isDeletable();
        this.isMergeable          = sobjectDescribe.isMergeable();
        this.isMruEnabled         = sobjectDescribe.isMruEnabled();
        this.isQueryable          = sobjectDescribe.isQueryable();
        this.isSearchable         = sobjectDescribe.isSearchable();
        this.isUndeletable        = sobjectDescribe.isUndeletable();
        this.isUpdateable         = sobjectDescribe.isUpdateable();
        this.keyPrefix            = sobjectDescribe.getKeyPrefix();
        this.label                = sobjectDescribe.getLabel();
        this.labelPlural          = sobjectDescribe.getLabelPlural();
        this.listViewApiNames     = ListViewMetadata.getListViewApiNames(String.valueOf(sobjectType));
        this.localApiName         = sobjectDescribe.getLocalName();
        this.namespace            = this.getNamespace();
        this.recordTypeApiNames   = RecordTypeMetadata.getRecordTypeApiNames(String.valueOf(sobjectType));
        this.tabIcon              = this.getTabIcon();
    }

    private String getDisplayFieldApiName(Schema.DescribeSObjectResult sobjectDescribe) {
        // There are several commonly used names for the display field name - typically, Name
        // Check the common names first before resorting to looping through all SObject fields
        // The order of the field names has been sorted based on number of objects in a dev org with that field
        List<String> educatedGuesses = new List<String>{
            'Name', 'DeveloperName', 'ApiName', 'Title', 'Subject',
            'AssetRelationshipNumber', 'CaseNumber', 'ContractNumber',
            'Domain', 'FriendlyName', 'FunctionName', 'Label', 'LocalPart',
            'OrderItemNumber', 'OrderNumber', 'SolutionName', 'TestSuiteName'
        };
        for(String fieldName : educatedGuesses) {
            Schema.SObjectField field = sobjectDescribe.fields.getMap().get(fieldName);

            if(field == null) continue;

            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if(fieldDescribe.isNameField()) return fieldDescribe.getName();
        }

        // If we still don't have the displayFieldName, then loop through all fields to find it
        for(Schema.SObjectField field : sobjectDescribe.fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if(fieldDescribe.isNameField()) return fieldDescribe.getName();
        }

        return null;
    }

    private List<String> getFieldApiNames(Schema.DescribeSObjectResult sobjectDescribe) {
        List<String> fieldApiNames = new List<String>();
        for(Schema.SObjectField field : sobjectDescribe.fields.getMap().values()) {
            fieldApiNames.add(String.valueOf(field));
        }
        return fieldApiNames;
    }

    private List<String> getFieldSetApiNames(Schema.DescribeSObjectResult sobjectDescribe) {
        List<String> fieldSetApiNames = new List<String>();
        for(Schema.FieldSet fieldSet : sobjectDescribe.fieldSets.getMap().values()) {
            String namespace = fieldSet.getNameSpace() == null ? '' : FieldSet.getNamespace() + '__';
            fieldSetApiNames.add(namespace + fieldSet.getName());
        }
        return fieldSetApiNames;
    }

    private String getNamespace() {
        Integer localNameIndex = this.apiName.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.apiName.substring(0, localNameIndex);
    }

    private String getTabIcon() {
        String tabIcon;
        for(Schema.DescribeTabSetResult tabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult tabResult : tabSetResult.getTabs()) {
                if(tabResult.getSObjectName() != this.apiName) continue;

                String iconType = tabResult.isCustom() ? 'custom' : 'standard';
                String svgIconName;
                for(Schema.DescribeIconResult icon : tabResult.getIcons()) {
                    if(icon.getContentType() != 'image/svg+xml') continue;

                    svgIconName = icon.getUrl().substringAfterLast('/').replace('.svg', '');
                    tabIcon = iconType + ':' + svgIconName;
                    break;
                }
            }
        }
        // Hardcoded exceptions - Salesforce doesn't return SVGs for these objects, so hardcoding is necessary
        if(tabIcon == null && this.apiName == 'Asset') tabIcon = 'standard:maintenance_asset';
        if(tabIcon == null && this.apiName == 'AssetRelationship') tabIcon = 'standard:asset_relationship';

        return tabIcon;
    }

}