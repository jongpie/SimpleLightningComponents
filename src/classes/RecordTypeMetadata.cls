/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
 global class RecordTypeMetadata implements Comparable {

    @AuraEnabled global final String ApiName        {get; private set;}
    @AuraEnabled global final Id Id                 {get; private set;}
    @AuraEnabled global final Boolean IsActive      {get; private set;}
    @AuraEnabled global final Boolean IsAvailable   {get; private set;}
    @AuraEnabled global final Boolean IsDefault     {get; private set;}
    @AuraEnabled global final Boolean IsMaster      {get; private set;}
    @AuraEnabled global final String Label          {get; private set;}
    @AuraEnabled global final String LocalApiName   {get; private set;}
    @AuraEnabled global final String Namespace      {get; private set;}
    @AuraEnabled global final String SobjectApiName {get; private set;}

    global RecordTypeMetadata(String sobjectApiName, String recordTypeApiName) {
        this(
            Schema.getGlobalDescribe().get(sobjectApiName),
            Schema.getGlobalDescribe().get(sobjectApiName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeApiName)
        );
    }

    global RecordTypeMetadata(Schema.SobjectType sobjectType, Id recordTypeId) {
        this(
            sobjectType,
            sobjectType.getDescribe().getRecordTypeInfosById().get(recordTypeId)
        );
    }

    global RecordTypeMetadata(Schema.SobjectType sobjectType, Schema.RecordTypeInfo recordTypeInfo) {
        this.ApiName        = this.getApiName(recordTypeInfo);
        this.Id             = recordTypeInfo.getRecordTypeId();
        this.IsActive       = recordTypeInfo.isActive();
        this.IsAvailable    = recordTypeInfo.isAvailable();
        this.IsDefault      = recordTypeInfo.isDefaultRecordTypeMapping();
        this.IsMaster       = recordTypeInfo.isMaster();
        this.Label          = recordTypeInfo.getName();
        this.LocalApiName   = this.getLocalApiName(recordTypeInfo.getDeveloperName());
        this.Namespace      = this.getNamespace(recordTypeInfo.getDeveloperName());
        this.SobjectApiName = String.valueOf(sobjectType);
    }

    global Integer compareTo(Object compareTo) {
        RecordTypeMetadata compareToRecordTypeMetadata = (RecordTypeMetadata)compareTo;
        String key          = this.SobjectApiName + this.ApiName;
        String compareToKey = compareToRecordTypeMetadata.SobjectApiName + compareToRecordTypeMetadata.ApiName;

        if(key == compareToKey) return 0;
        else if(key > compareToKey) return 1;
        else return -1;
    }

    private String getApiName(Schema.RecordTypeInfo recordTypeInfo) {
        String namespacePrefix = String.isEmpty(this.getNamespace(recordTypeInfo.getDeveloperName())) ? '' : this.getNamespace(recordTypeInfo.getDeveloperName()) + '__';
        return namespacePrefix + recordTypeInfo.getDeveloperName();
    }

    private String getLocalApiName(String apiName) {
        return apiName.contains('__') ? apiName.substringAfter('__') : apiName;
    }

    private String getNamespace(String apiName) {
        return apiName.contains('__') ? apiName.substringBefore('__') : null;
    }

}