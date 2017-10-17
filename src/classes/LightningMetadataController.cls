public with sharing class LightningMetadataController {

    @AuraEnabled
    public static SObjectMetadata getSObjectMetadata(String sobjectName) {
        return new SObjectMetadata(sobjectName);
    }

    @AuraEnabled
    public static FieldMetadata getFieldMetadata(String sobjectName, String fieldName) {
        return new FieldMetadata(sobjectName, fieldName);
    }

    public class SObjectMetadata {

        @AuraEnabled public String name {get;private set;}
        @AuraEnabled public String label {get;private set;}
        @AuraEnabled public String labelPlural {get;private set;}
        @AuraEnabled public String nameField {get;private set;}
        @AuraEnabled public Set<String> allFields {get;private set;}
        @AuraEnabled public Set<String> accessibleFields {get;private set;}
        @AuraEnabled public Set<String> createableFields {get;private set;}
        @AuraEnabled public Set<String> updateableFields {get;private set;}

        public Schema.DescribeSObjectResult sobjectDescribe {get;private set;}

        public SObjectMetadata(String sobjectName) {
            this.name = sobjectName;

            this.sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();

            this.label       = this.sobjectDescribe.getLabel();
            this.labelPlural = this.sobjectDescribe.getLabelPlural();

            this.setNameField();
            this.setFieldLists();
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

        private void setFieldLists() {
            for(Schema.SObjectField field : this.sobjectDescribe.fields.getMap().values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                String fieldName = fieldDescribe.getName();

                this.allFields.add(fieldName);
                if(fieldDescribe.isAccessible()) this.accessibleFields.add(fieldName);
                if(fieldDescribe.isCreateable()) this.accessibleFields.add(fieldName);
                if(fieldDescribe.isUpdateable()) this.updateableFields.add(fieldName);
            }
        }

    }

    public class FieldMetadata {

        @AuraEnabled public String sobjectName {get;private set;}
        @AuraEnabled public String name {get;private set;}
        @AuraEnabled public String displayType {get;private set;}
        @AuraEnabled public String inlineHelpText {get;private set;}
        @AuraEnabled public String label {get;private set;}
        @AuraEnabled public Boolean required {get;private set;}
        @AuraEnabled public Integer maxLength {get;private set;}
        @AuraEnabled public Object defaultValue {get;private set;}
        @AuraEnabled public List<PicklistEntryMetadata> picklistOptions {get;private set;}

        public Schema.DescribeFieldResult fieldDescribe {get;private set;}

        public FieldMetadata(String sobjectName, String fieldName) {
            this.sobjectName     = sobjectName;
            this.name            = fieldName;
            this.picklistOptions = new List<PicklistEntryMetadata>();

            this.fieldDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();

            this.displayType    = fieldDescribe.getType().name();
            this.inlineHelpText = fieldDescribe.getInlineHelpText();
            this.label          = fieldDescribe.getLabel();
            this.required       = !this.fieldDescribe.isNillable(); // If a field is NOT nillable, then it's required
            this.maxLength      = this.fieldDescribe.getLength();
            this.defaultValue   = this.fieldDescribe.getDefaultValue();

            this.setPicklistOptions();
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

    private class PicklistEntryMetadata {

        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}
        @AuraEnabled public Boolean isDefaultValue {get;set;}

        private Schema.PicklistEntry picklistEntry;

        public PicklistEntryMetadata() {
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