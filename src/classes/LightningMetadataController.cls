public with sharing class LightningMetadataController {

    @AuraEnabled
    public static SObjectMetadata getSObjectMetadata(String sobjectName) {
        return new SObjectMetadata(sobjectName);
    }

    @AuraEnabled
    public static FieldMetadata getFieldMetadata(String sobjectName, string fieldName) {
        return new FieldMetadata(sobjectName, fieldName);
    }

    public class SObjectMetadata {

        @AuraEnabled public String sobjectName {get;private set;}
        @AuraEnabled public String sobjectLabel {get;private set;}
        @AuraEnabled public String sobjectLabelPlural {get;private set;}
        @AuraEnabled public String nameField {get;private set;}
        @AuraEnabled public Set<String> fieldNames {get;private set;}

        public Schema.DescribeSObjectResult sobjectDescribe {get;private set;}

        public SObjectMetadata(String sobjectName) {
            this.sobjectName = sobjectName;

            this.sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();

            this.setSObjectLabels();
            this.setNameField();
            this.setFieldNames();
        }

        private void setSObjectLabels() {
            this.sobjectLabel       = this.sobjectDescribe.getLabel();
            this.sobjectLabelPlural = this.sobjectDescribe.getLabelPlural();
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

        private void setFieldNames() {
            this.fieldNames = this.sobjectDescribe.fields.getMap().keySet();
        }

    }

    public class FieldMetadata {

        @AuraEnabled public String sobjectName {get;private set;}
        @AuraEnabled public String fieldName {get;private set;}
        @AuraEnabled public String fieldType {get;private set;}
        @AuraEnabled public String fieldInlineHelpText {get;private set;}
        @AuraEnabled public String fieldLabel {get;private set;}
        @AuraEnabled public Boolean fieldRequired {get;private set;}
        @AuraEnabled public Integer fieldMaxLength {get;private set;}
        @AuraEnabled public Object fieldDefaultValue {get;private set;}
        @AuraEnabled public List<PicklistEntryMetadata> picklistOptions {get;private set;}

        public Schema.DescribeFieldResult fieldDescribe {get;private set;}

        public FieldMetadata(String sobjectName, String fieldName) {
            this.sobjectName     = sobjectName;
            this.fieldName       = fieldName;
            this.picklistOptions = new List<PicklistEntryMetadata>();

            this.fieldDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();

            this.setFieldType();
            this.setFieldInlineHelpText();
            this.setFieldLabel();
            this.setFieldRequired();
            this.setFieldMaxLength();
            this.setFieldDefaultValue();
            this.setPicklistOptions();
        }

        private void setFieldType() {
            this.fieldType = fieldDescribe.getType().name();
        }

        private void setFieldInlineHelpText() {
            this.fieldInlineHelpText = fieldDescribe.getInlineHelpText();
        }

        private void setFieldLabel() {
            this.fieldLabel = fieldDescribe.getLabel();
        }

        private void setFieldRequired() {
            // If a field is NOT nillable, then it's required
            this.fieldRequired = !this.fieldDescribe.isNillable();
        }

        private void setFieldMaxLength() {
            this.fieldMaxLength = this.fieldDescribe.getLength();
        }

        private void setFieldDefaultValue() {
            this.fieldDefaultValue = this.fieldDescribe.getDefaultValue();
        }

        private void setPicklistOptions() {
            Schema.DisplayType fieldDisplayType = this.fieldDescribe.getType();
            if(fieldDisplayType != Schema.DisplayType.Picklist && fieldDisplayType != Schema.DisplayType.MultiPicklist) return;

            Schema.DescribeSObjectResult sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();
            Schema.DescribeFieldResult fieldDescribe = sobjectDescribe.fields.getMap().get(fieldName).getDescribe();

            this.picklistOptions.add(new PicklistEntryMetadata()); // Empty picklist value
            for(Schema.PicklistEntry picklistEntry : this.fieldDescribe.getPickListValues()) {
                this.picklistOptions.add(new PicklistEntryMetadata(picklistEntry));
            }
        }
    }

    private class PicklistEntryMetadata {

        @AuraEnabled public String picklistLabel {get;set;}
        @AuraEnabled public String picklistValue {get;set;}
        @AuraEnabled public Boolean isDefaultValue {get;set;}

        private Schema.PicklistEntry picklistEntry;

        public PicklistEntryMetadata() {
            this.isDefaultValue = false;
        }

        public PicklistEntryMetadata(Schema.PicklistEntry picklistEntry) {
            this.picklistEntry  = picklistEntry;
            this.isDefaultValue = picklistEntry.isDefaultValue();

            this.picklistLabel = picklistEntry.getLabel();
            this.picklistValue = picklistEntry.getValue();
        }

    }

}