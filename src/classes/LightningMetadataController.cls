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

        @AuraEnabled public String sobjectName {get;set;}
        @AuraEnabled public String sobjectLabel {get;set;}
        @AuraEnabled public String sobjectLabelPlural {get;set;}

        private Schema.DescribeSObjectResult sobjectDescribe;

        public SObjectMetadata(String sobjectName) {
            this.sobjectName = sobjectName;

            this.sobjectDescribe = Schema.getGlobalDescribe().get(sobjectName).getDescribe();

            this.setSObjectLabels();
        }

        private void setSObjectLabels() {
            this.sobjectLabel       = this.sobjectDescribe.getLabel();
            this.sobjectLabelPlural = this.sobjectDescribe.getLabelPlural();
        }

    }

    public class FieldMetadata {

        @AuraEnabled public String sobjectName {get;set;}
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldType {get;set;}
        @AuraEnabled public String fieldInlineHelpText {get;set;}
        @AuraEnabled public String fieldLabel {get;set;}
        @AuraEnabled public Boolean fieldRequired {get;set;}
        @AuraEnabled public Integer fieldMaxLength {get;set;}
        @AuraEnabled public Object fieldDefaultValue {get;set;}
        @AuraEnabled public List<PicklistEntryMetadata> picklistOptions {get;set;}

        private Schema.DescribeFieldResult fieldDescribe;

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

    public class PicklistEntryMetadata {

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