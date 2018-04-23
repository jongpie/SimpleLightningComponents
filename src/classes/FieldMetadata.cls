/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class FieldMetadata {

    @AuraEnabled global final String apiName                               {get; private set;}
    @AuraEnabled global final Integer byteLength                           {get; private set;}
    @AuraEnabled global final Object defaultValue                          {get; private set;}
    @AuraEnabled global final Integer digits                               {get; private set;}
    @AuraEnabled global final String displayType                           {get; private set;}
    @AuraEnabled global final String inlineHelpText                        {get; private set;}
    @AuraEnabled global final Boolean isAccessible                         {get; private set;}
    @AuraEnabled global final Boolean isAutoNumber                         {get; private set;}
    @AuraEnabled global final Boolean isCalculated                         {get; private set;}
    @AuraEnabled global final Boolean isCaseSensitive                      {get; private set;}
    @AuraEnabled global final Boolean isCreateable                         {get; private set;}
    @AuraEnabled global final Boolean isCustom                             {get; private set;}
    @AuraEnabled global final Boolean isDefaultedOnCreate                  {get; private set;}
    @AuraEnabled global final Boolean isFilterable                         {get; private set;}
    @AuraEnabled global final Boolean isGroupable                          {get; private set;}
    @AuraEnabled global final Boolean isNameField                          {get; private set;}
    @AuraEnabled global final Boolean isNillable                           {get; private set;}
    @AuraEnabled global final Boolean isRequired                           {get; private set;}
    @AuraEnabled global final Boolean isSortable                           {get; private set;}
    @AuraEnabled global final Boolean isUpdateable                         {get; private set;}
    @AuraEnabled global final String label                                 {get; private set;}
    @AuraEnabled global final String localApiName                          {get; private set;}
    @AuraEnabled global final Integer maxLength                            {get; private set;}
    @AuraEnabled global final String namespace                             {get; private set;}
    @AuraEnabled global final List<PicklistEntryMetadata> picklistOptions  {get; private set;}
    @AuraEnabled global final Integer precision                            {get; private set;}
    @AuraEnabled global final String relationshipName                      {get; private set;}
    @AuraEnabled global final Integer relationshipOrder                    {get; private set;}
    @AuraEnabled global final List<SObjectMetadata> relationshipReferences {get; private set;} // TODO consider changing to string[] of names instead
    @AuraEnabled global final Integer scale                                {get; private set;}
    @AuraEnabled global final String soapType                              {get; private set;}
    @AuraEnabled global final String sobjectApiName                        {get; private set;}

    global FieldMetadata(String sobjectApiName, String fieldApiName) {
        this(
            Schema.getGlobalDescribe().get(sobjectApiName),
            Schema.getGlobalDescribe().get(sobjectApiName).getDescribe().fields.getMap().get(fieldApiName)
        );
    }

    global FieldMetadata(Schema.SObjectType sobjectType, Schema.SObjectField sobjectField) {
        Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();
        Schema.DescribeFieldResult fieldDescribe     = sobjectField.getDescribe();

        this.apiName                = String.valueOf(sobjectField);
        this.byteLength             = fieldDescribe.getByteLength();
        this.defaultValue           = fieldDescribe.getDefaultValue();
        this.digits                 = fieldDescribe.getDigits();
        this.displayType            = fieldDescribe.getType().name();
        this.inlineHelpText         = fieldDescribe.getInlineHelpText();
        this.isAccessible           = fieldDescribe.isAccessible();
        this.isAutoNumber           = fieldDescribe.isAutoNumber();
        this.isCalculated           = fieldDescribe.isCalculated();
        this.isCaseSensitive        = fieldDescribe.isCaseSensitive();
        this.isCreateable           = fieldDescribe.isCreateable();
        this.isCustom               = fieldDescribe.isCustom();
        this.isDefaultedOnCreate    = fieldDescribe.isDefaultedOnCreate();
        this.isFilterable           = fieldDescribe.isFilterable();
        this.isGroupable            = fieldDescribe.isGroupable();
        this.isNameField            = fieldDescribe.isNameField();
        this.isNillable             = fieldDescribe.isNillable();
        this.isRequired             = fieldDescribe.isNillable() == false && fieldDescribe.isCreateable(); // If a field is NOT nillable, then it's required
        this.isSortable             = fieldDescribe.isSortable();
        this.isUpdateable           = fieldDescribe.isUpdateable();
        this.label                  = fieldDescribe.getLabel();
        this.localApiName           = fieldDescribe.getLocalName();
        this.maxLength              = fieldDescribe.getLength();
        this.namespace              = this.getNamespace();
        this.picklistOptions        = this.getPicklistOptions(fieldDescribe);
        this.precision              = fieldDescribe.getPrecision();
        this.relationshipName       = fieldDescribe.getRelationshipName();
        this.relationshipOrder      = fieldDescribe.getRelationshipOrder();
        this.relationshipReferences = this.getRelationshipReferences(fieldDescribe);
        this.scale                  = fieldDescribe.getScale();
        this.soapType               = fieldDescribe.getSOAPType().name();
        this.sobjectApiName         = String.valueOf(sobjectType);
    }

    private String getNamespace() {
        Integer localNameIndex = this.apiName.replace('__c', '').indexOf('__');
        return localNameIndex < 0 ? null : this.apiName.substring(0, localNameIndex);
    }

    private List<PicklistEntryMetadata> getPicklistOptions(Schema.DescribeFieldResult fieldDescribe) {
        List<PicklistEntryMetadata> picklistOptions = new List<PicklistEntryMetadata>();

        if(fieldDescribe.getPickListValues().isEmpty()) return picklistOptions;

        picklistOptions.add(new PicklistEntryMetadata()); // Add an empty picklist value
        for(Schema.PicklistEntry picklistEntry : fieldDescribe.getPickListValues()) {
            picklistOptions.add(new PicklistEntryMetadata(picklistEntry));
        }
        return picklistOptions;
    }

    private List<SObjectMetadata> getRelationshipReferences(Schema.DescribeFieldResult fieldDescribe) {
        List<SObjectMetadata> relationshipReferences = new List<SObjectMetadata>();
        for(Schema.SObjectType sobjectType : fieldDescribe.getReferenceTo()) {
            relationshipReferences.add(new SObjectMetadata(sobjectType));
        }
        return relationshipReferences;
    }

    global virtual class PicklistEntryMetadata {

        @AuraEnabled global final Boolean isDefaultValue {get; private set;}
        @AuraEnabled global final String label           {get; private set;}
        @AuraEnabled global final String value           {get; private set;}

        global PicklistEntryMetadata() {
            this.isDefaultValue = false;
            this.label          = '--None--';
            this.value          = '';
        }

        global PicklistEntryMetadata(Schema.PicklistEntry picklistEntry) {
            this.isDefaultValue = picklistEntry.isDefaultValue();
            this.label          = picklistEntry.getLabel();
            this.value          = picklistEntry.getValue();
        }

    }

}