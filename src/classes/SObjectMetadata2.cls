global class SObjectMetadata2 {


    @AuraEnabled global final Boolean hasMultiCurrency             {get; private set;}
    @AuraEnabled global final Boolean hasSubtypes                  {get; private set;}
    @AuraEnabled global final Boolean isAccessible                 {get; private set;}
    @AuraEnabled global final Boolean isChatterFeedEnabled         {get; private set;}
    @AuraEnabled global final Boolean isCreateable                 {get; private set;}
    @AuraEnabled global final Boolean isCustom                     {get; private set;}
    @AuraEnabled global final Boolean isCustomSetting              {get; private set;}
    @AuraEnabled global final Boolean isDeletable                  {get; private set;}
    @AuraEnabled global final Boolean isMruEnabled                 {get; private set;}
    @AuraEnabled global final Boolean isMergeable                  {get; private set;}
    @AuraEnabled global final Boolean isQueryable                  {get; private set;}
    @AuraEnabled global final Boolean isSearchable                 {get; private set;}
    @AuraEnabled global final Boolean isUndeletable                {get; private set;}
    @AuraEnabled global final Boolean isUpdateable                 {get; private set;}
    @AuraEnabled global final Fields fields                        {get; private set;}
    @AuraEnabled global final List<String> fieldSetNames           {get; private set;}
    @AuraEnabled global final String keyPrefix                     {get; private set;}
    @AuraEnabled global final String label                         {get; private set;}
    @AuraEnabled global final String labelPlural                   {get; private set;}
    @AuraEnabled global final String localName                     {get; private set;}
    @AuraEnabled global final String name                          {get; private set;}
    @AuraEnabled global final String namespace                     {get; private set;}
    @AuraEnabled global final List<RecordTypeMetadata> recordTypes {get; private set;}
    @AuraEnabled global final String tabIcon                       {get; private set;}

    global SObjectMetadata2(String sobjectName) {
        this(Schema.getGlobalDescribe().get(sobjectName));
    }

    global SObjectMetadata2(Schema.SObjectType sobjectType) {
        DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();

        this.fields               = new Fields(sobjectDescribe);
        this.fieldSetNames        = this.getFieldSetNames(sobjectDescribe);
        this.hasMultiCurrency     = sobjectDescribe.fields.getMap().containsKey('CurrencyIsoCode');
        this.hasSubtypes          = sobjectDescribe.getHasSubtypes();
        this.isAccessible         = sobjectDescribe.isAccessible();
        this.isChatterFeedEnabled = sobjectDescribe.isFeedEnabled();
        this.isCreateable         = sobjectDescribe.isCreateable();
        this.isCustom             = sobjectDescribe.isCustom();
        this.isCustomSetting      = sobjectDescribe.isCustomSetting();
        this.isDeletable          = sobjectDescribe.isDeletable();
        this.isMergeable          = sobjectDescribe.isMergeable();
        this.isMRUEnabled         = sobjectDescribe.isMruEnabled();
        this.isQueryable          = sobjectDescribe.isQueryable();
        this.isSearchable         = sobjectDescribe.isSearchable();
        this.isUndeletable        = sobjectDescribe.isUndeletable();
        this.isUpdateable         = sobjectDescribe.isUpdateable();
        this.keyPrefix            = sobjectDescribe.getKeyPrefix();
        this.label                = sobjectDescribe.getLabel();
        this.labelPlural          = sobjectDescribe.getLabelPlural();
        this.localName            = sobjectDescribe.getLocalName();
        this.name                 = String.valueOf(sobjectType);
        this.namespace            = this.getNamespace();
        this.recordTypes          = this.getRecordTypes(sobjectType, sobjectDescribe);
        this.tabIcon              = this.getTabIcon();
    }

    private List<String> getFieldSetNames(Schema.DescribeSObjectResult sobjectDescribe) {
        List<String> fieldSetNames = new List<String>();
        for(Schema.FieldSet fieldSet : sobjectDescribe.fieldSets.getMap().values()) {
            fieldSetNames.add(fieldSet.getName());
        }
        return fieldSetNames;
    }

    private String getNamespace() {
        Integer localNameIndex = this.name.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.name.substring(0, localNameIndex);
    }

    private List<RecordTypeMetadata> getRecordTypes(Schema.SObjectType sobjectType, Schema.DescribeSObjectResult sobjectDescribe) {
        List<RecordTypeMetadata> recordTypes = new List<RecordTypeMetadata>();
        for(Schema.RecordTypeInfo recordTypeInfo : sobjectDescribe.getRecordTypeInfos()) {
            recordTypes.add(new RecordTypeMetadata(sobjectType, recordTypeInfo));
        }
        return recordTypes;
    }

    private String getTabIcon() {
        String tabIcon;
        for(Schema.DescribeTabSetResult tabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult tabResult : tabSetResult.getTabs()) {
                if(tabResult.getSObjectName() != this.name) continue;

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
        if(tabIcon == null && this.name == 'Asset') tabIcon = 'standard:maintenance_asset';
        if(tabIcon == null && this.name == 'AssetRelationship') tabIcon = 'standard:asset_relationship';

        return tabIcon;
    }

    global virtual class Fields {

        @AuraEnabled global final String nameField                  {get; private set;}
        @AuraEnabled global final List<String> accessibleFieldNames {get; private set;}
        @AuraEnabled global final List<String> allFieldNames        {get; private set;}
        @AuraEnabled global final List<String> createableFieldNames {get; private set;}
        @AuraEnabled global final List<String> requiredFieldNames   {get; private set;}
        @AuraEnabled global final List<String> updateableFieldNames {get; private set;}

        global Fields(Schema.DescribeSObjectResult sobjectDescribe) {
            this.accessibleFieldNames = new List<String>();
            this.allFieldNames        = new List<String>();
            this.createableFieldNames = new List<String>();
            this.requiredFieldNames   = new List<String>();
            this.updateableFieldNames = new List<String>();

            for(Schema.SObjectField field : sobjectDescribe.fields.getMap().values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                String fieldName = fieldDescribe.getName();

                if(fieldDescribe.isNameField()) this.nameField = fieldDescribe.getName();

                this.allFieldNames.add(fieldName);
                if(fieldDescribe.isAccessible()) this.accessibleFieldNames.add(fieldName);
                if(fieldDescribe.isCreateable()) this.createableFieldNames.add(fieldName);
                if(fieldDescribe.isNillable() == false && fieldDescribe.isCreateable()) this.requiredFieldNames.add(fieldName);
                if(fieldDescribe.isUpdateable()) this.updateableFieldNames.add(fieldName);
            }
        }

    }

}