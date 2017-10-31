public with sharing class LightningMetadataController {

    @AuraEnabled
    public static SObjectMetadata getSObjectMetadata(String sobjectName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getSObjectMetadata(\'' + sobjectName + '\')');

        return new SObjectMetadata(sobjectName);
    }

    @AuraEnabled
    public static FieldMetadata getFieldMetadata(String sobjectName, String fieldName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadata(\'' + sobjectName + '\', \'' + fieldName + '\')');

        return new FieldMetadata(sobjectName, fieldName);
    }

    @AuraEnabled
    public static List<FieldMetadata> getFieldSetMetadata(String sobjectName, String fieldSetName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldSetMetadata(\'' + sobjectName + '\', \'' + fieldSetName + '\')');

        Schema.DescribeSObjectResult sobjectDescribe = new SObjectMetadata(sobjectName).sobjectDescribe;
        Schema.FieldSet fieldSet = sobjectDescribe.fieldSets.getMap().get(fieldSetName);

        List<FieldMetadata> fieldSetMetadata = new List<FieldMetadata>();
        for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            FieldMetadata fieldMetadata = new FieldMetadata(sobjectName, fieldSetMember.getFieldPath());
            fieldMetadata.required = (fieldSetMember.getDBRequired() || fieldSetMember.getRequired());

            fieldSetMetadata.add(fieldMetadata);
        }
        return fieldSetMetadata;
    }

    public class SObjectMetadata {

        @AuraEnabled public String name                               {get;private set;}
        @AuraEnabled public String label                              {get;private set;}
        @AuraEnabled public String labelPlural                        {get;private set;}
        @AuraEnabled public String nameField                          {get;private set;}
        @AuraEnabled public SObjectLevelSecurity sobjectLevelSecurity {get;private set;}

        public Schema.DescribeSObjectResult sobjectDescribe {get;private set;}

        public SObjectMetadata(String sobjectName) {
            this.name            = sobjectName;
            this.sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();

            this.label       = this.sobjectDescribe.getLabel();
            this.labelPlural = this.sobjectDescribe.getLabelPlural();

            this.setNameField();
            this.setSObjectLevelSecurity();
        }

        private void setNameField() {
            for(Schema.SObjectField field : this.sobjectDescribe.fields.getMap().values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

                if(fieldDescribe.isNameField()) {
                    this.nameField = fieldDescribe.getName();
                    break;
                }
            }
        }

        private void setSObjectLevelSecurity() {
            this.sobjectLevelSecurity = new SObjectLevelSecurity();
            this.sobjectLevelSecurity.isAccessible  = this.sobjectDescribe.isAccessible();
            this.sobjectLevelSecurity.isCreateable  = this.sobjectDescribe.isCreateable();
            this.sobjectLevelSecurity.isDeletable   = this.sobjectDescribe.isDeletable();
            this.sobjectLevelSecurity.isUpdateable  = this.sobjectDescribe.isUpdateable();
            this.sobjectLevelSecurity.isUndeletable = this.sobjectDescribe.isUndeletable();
        }

    }

    private class SObjectLevelSecurity {
        @AuraEnabled public Boolean isAccessible  {get;private set;}
        @AuraEnabled public Boolean isCreateable  {get;private set;}
        @AuraEnabled public Boolean isUpdateable  {get;private set;}
        @AuraEnabled public Boolean isDeletable   {get;private set;}
        @AuraEnabled public Boolean isUndeletable {get;private set;}
    }

    public class FieldMetadata {

        @AuraEnabled public String name                                 {get;private set;}
        @AuraEnabled public String sobjectName                          {get;private set;}
        @AuraEnabled public Object defaultValue                         {get;private set;}
        @AuraEnabled public String displayType                          {get;private set;}
        @AuraEnabled public String inlineHelpText                       {get;private set;}
        @AuraEnabled public Boolean isDefaultedOnCreate                 {get;private set;}
        @AuraEnabled public Boolean isFilterable                        {get;private set;}
        @AuraEnabled public Boolean isSortable                          {get;private set;}
        @AuraEnabled public String label                                {get;private set;}
        @AuraEnabled public Integer maxLength                           {get;private set;}
        @AuraEnabled public Boolean required                            {get;private set;}
        @AuraEnabled public FieldLevelSecurity fieldLevelSecurity       {get;private set;}
        @AuraEnabled public List<PicklistEntryMetadata> picklistOptions {get;private set;}

        public Schema.DescribeFieldResult fieldDescribe {get;private set;}

        public FieldMetadata(String sobjectName, String fieldName) {
            this.sobjectName     = sobjectName;
            this.name            = fieldName;
            this.picklistOptions = new List<PicklistEntryMetadata>();

            this.fieldDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();

            this.defaultValue        = this.fieldDescribe.getDefaultValue();
            this.displayType         = this.fieldDescribe.getType().name();
            this.inlineHelpText      = this.fieldDescribe.getInlineHelpText();
            this.isDefaultedOnCreate = this.fieldDescribe.isDefaultedOnCreate();
            this.isFilterable        = this.fieldDescribe.isFilterable();
            this.isSortable          = this.fieldDescribe.isSortable();
            this.label               = this.fieldDescribe.getLabel();
            this.maxLength           = this.fieldDescribe.getLength();
            this.required            = this.fieldDescribe.isNillable() == false; // If a field is NOT nillable, then it's required

            this.setFieldLevelSecurity();
            this.setPicklistOptions();
        }

        private void setFieldLevelSecurity() {
            this.fieldLevelSecurity = new FieldLevelSecurity();
            this.fieldLevelSecurity.isAccessible = this.fieldDescribe.isAccessible();
            this.fieldLevelSecurity.isCreateable = this.fieldDescribe.isCreateable();
            this.fieldLevelSecurity.isUpdateable = this.fieldDescribe.isUpdateable();
        }

        private void setPicklistOptions() {
            Schema.DisplayType fieldDisplayType = this.fieldDescribe.getType();
            if(fieldDisplayType != Schema.DisplayType.Picklist && fieldDisplayType != Schema.DisplayType.MultiPicklist) return;

            this.picklistOptions.add(new PicklistEntryMetadata()); // Empty picklist value
            for(Schema.PicklistEntry picklistEntry : this.fieldDescribe.getPickListValues()) {
                this.picklistOptions.add(new PicklistEntryMetadata(picklistEntry));
            }
        }
    }

    private class FieldLevelSecurity {
        @AuraEnabled public Boolean isAccessible {get;private set;}
        @AuraEnabled public Boolean isCreateable {get;private set;}
        @AuraEnabled public Boolean isUpdateable {get;private set;}
    }

    private class PicklistEntryMetadata {

        @AuraEnabled public String label           {get;private set;}
        @AuraEnabled public String value           {get;private set;}
        @AuraEnabled public Boolean isDefaultValue {get;private set;}

        private Schema.PicklistEntry picklistEntry;

        public PicklistEntryMetadata() {
            this.label          = '';
            this.value          = '';
            this.isDefaultValue = false;
        }

        public PicklistEntryMetadata(Schema.PicklistEntry picklistEntry) {
            this.picklistEntry  = picklistEntry;

            this.label          = picklistEntry.getLabel();
            this.value          = picklistEntry.getValue();
            this.isDefaultValue = picklistEntry.isDefaultValue();
        }

    }

}