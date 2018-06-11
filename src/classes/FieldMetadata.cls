/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class FieldMetadata {

    @AuraEnabled global final String ApiName                               {get; private set;}
    @AuraEnabled global final Integer ByteLength                           {get; private set;}
    @AuraEnabled global final Object DefaultValue                          {get; private set;}
    @AuraEnabled global final Integer Digits                               {get; private set;}
    @AuraEnabled global final String DisplayType                           {get; private set;}
    @AuraEnabled global final String InlineHelpText                        {get; private set;}
    @AuraEnabled global final Boolean IsAccessible                         {get; private set;}
    @AuraEnabled global final Boolean IsAutoNumber                         {get; private set;}
    @AuraEnabled global final Boolean IsCalculated                         {get; private set;}
    @AuraEnabled global final Boolean IsCaseSensitive                      {get; private set;}
    @AuraEnabled global final Boolean IsCreateable                         {get; private set;}
    @AuraEnabled global final Boolean IsCustom                             {get; private set;}
    @AuraEnabled global final Boolean IsDefaultedOnCreate                  {get; private set;}
    @AuraEnabled global final Boolean IsFilterable                         {get; private set;}
    @AuraEnabled global final Boolean IsGroupable                          {get; private set;}
    @AuraEnabled global final Boolean IsNameField                          {get; private set;}
    @AuraEnabled global final Boolean IsNillable                           {get; private set;}
    @AuraEnabled global final Boolean IsNamePointing                       {get; private set;}
    @AuraEnabled global final Boolean IsRequired                           {get; private set;}
    @AuraEnabled global final Boolean IsSortable                           {get; private set;}
    @AuraEnabled global final Boolean IsUpdateable                         {get; private set;}
    @AuraEnabled global final String Label                                 {get; private set;}
    @AuraEnabled global final String LocalApiName                          {get; private set;}
    @AuraEnabled global final Integer MaxLength                            {get; private set;}
    @AuraEnabled global final String Namespace                             {get; private set;}
    @AuraEnabled global final List<PicklistEntryMetadata> PicklistOptions  {get; private set;}
    @AuraEnabled global final Integer Precision                            {get; private set;}
    @AuraEnabled global final String RelationshipApiName                   {get; private set;}
    @AuraEnabled global final Integer RelationshipOrder                    {get; private set;}
    @AuraEnabled global final List<SobjectMetadata> RelationshipReferences {get; private set;}
    @AuraEnabled global final Integer Scale                                {get; private set;}
    @AuraEnabled global final String SobjectApiName                        {get; private set;}

    global FieldMetadata(String sobjectApiName, String fieldApiName) {
        this(
            Schema.getGlobalDescribe().get(sobjectApiName),
            Schema.getGlobalDescribe().get(sobjectApiName).getDescribe().fields.getMap().get(fieldApiName)
        );
    }

    global FieldMetadata(Schema.SobjectType sobjectType, Schema.SobjectField sobjectField) {
        Schema.DescribeSobjectResult sobjectDescribe = sobjectType.getDescribe();
        Schema.DescribeFieldResult fieldDescribe     = sobjectField.getDescribe();

        this.ApiName                = String.valueOf(sobjectField);
        this.ByteLength             = fieldDescribe.getByteLength();
        this.DefaultValue           = fieldDescribe.getDefaultValue();
        this.Digits                 = fieldDescribe.getDigits();
        this.DisplayType            = fieldDescribe.getType().name();
        this.InlineHelpText         = fieldDescribe.getInlineHelpText();
        this.IsAccessible           = fieldDescribe.isAccessible();
        this.IsAutoNumber           = fieldDescribe.isAutoNumber();
        this.IsCalculated           = fieldDescribe.isCalculated();
        this.IsCaseSensitive        = fieldDescribe.isCaseSensitive();
        this.IsCreateable           = fieldDescribe.isCreateable();
        this.IsCustom               = fieldDescribe.isCustom();
        this.IsDefaultedOnCreate    = fieldDescribe.isDefaultedOnCreate();
        this.IsFilterable           = fieldDescribe.isFilterable();
        this.IsGroupable            = fieldDescribe.isGroupable();
        this.IsNameField            = fieldDescribe.isNameField();
        this.IsNillable             = fieldDescribe.isNillable();
        this.IsNamePointing         = fieldDescribe.isNamePointing();
        this.IsRequired             = fieldDescribe.isNillable() == false && fieldDescribe.isCreateable(); // If a field is NOT nillable, then it's required
        this.IsSortable             = fieldDescribe.isSortable();
        this.IsUpdateable           = fieldDescribe.isUpdateable();
        this.Label                  = fieldDescribe.getLabel();
        this.LocalApiName           = fieldDescribe.getLocalName();
        this.MaxLength              = fieldDescribe.getLength();
        this.Namespace              = this.getNamespace();
        this.PicklistOptions        = this.getPicklistOptions(fieldDescribe);
        this.Precision              = fieldDescribe.getPrecision();
        this.RelationshipApiName    = fieldDescribe.getRelationshipName();
        this.RelationshipOrder      = fieldDescribe.getRelationshipOrder();
        this.RelationshipReferences = this.getRelationshipReferences(fieldDescribe);
        this.Scale                  = fieldDescribe.getScale();
        this.SobjectApiName         = String.valueOf(sobjectType);
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

    private List<SobjectMetadata> getRelationshipReferences(Schema.DescribeFieldResult fieldDescribe) {
        List<SobjectMetadata> relationshipReferences = new List<SobjectMetadata>();
        for(Schema.SobjectType sobjectType : fieldDescribe.getReferenceTo()) {
            relationshipReferences.add(new SobjectMetadata(sobjectType));
        }
        return relationshipReferences;
    }

    global class PicklistEntryMetadata {

        @AuraEnabled global final Boolean IsDefaultValue {get; private set;}
        @AuraEnabled global final String Label           {get; private set;}
        @AuraEnabled global final String Value           {get; private set;}

        global PicklistEntryMetadata() {
            this.IsDefaultValue = false;
            this.Label          = '';
            this.Value          = '';
        }

        global PicklistEntryMetadata(Schema.PicklistEntry picklistEntry) {
            this.IsDefaultValue = picklistEntry.isDefaultValue();
            this.Label          = picklistEntry.getLabel();
            this.Value          = picklistEntry.getValue();
        }

    }

}