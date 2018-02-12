/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class FieldSetMetadata {

    @AuraEnabled global final String apiName                               {get; private set;}
    @AuraEnabled global final String description                           {get; private set;}
    @AuraEnabled global final List<FieldSetMemberMetadata> fieldSetMembers {get; private set;}
    @AuraEnabled global final String label                                 {get; private set;}
    @AuraEnabled global final String localApiName                          {get; private set;}
    @AuraEnabled global final String namespace                             {get; private set;}
    @AuraEnabled global final String sobjectApiName                        {get; private set;}

    global FieldSetMetadata(String sobjectApiName, String fieldSetApiName) {
        this(Schema.getGlobalDescribe().get(sobjectApiName).getDescribe().fieldSets.getMap().get(fieldSetApiName));
    }

    global FieldSetMetadata(Schema.FieldSet fieldSet) {
        // SObject name & field name are used to set other values, so set them first
        this.sobjectApiName = String.valueOf(fieldSet.getSObjectType());
        this.apiName        = (fieldSet.getNamespace() == null ? '' : fieldSet.getNamespace() + '__') + fieldSet.getName();

        this.description     = fieldSet.getDescription();
        this.fieldSetMembers = this.getFieldSetMembers(fieldSet);
        this.label           = fieldSet.getLabel();
        this.localApiName    = this.getLocalApiName();
        this.namespace       = fieldSet.getNamespace();
    }

    private List<FieldSetMemberMetadata> getFieldSetMembers(Schema.FieldSet fieldSet) {
        List<FieldSetMemberMetadata> fieldSetMembers = new List<FieldSetMemberMetadata>();
        for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            FieldSetMemberMetadata fieldSetMemberMetadata = new FieldSetMemberMetadata(this.sobjectApiName, fieldSetMember);

            fieldSetMembers.add(fieldSetMemberMetadata);
        }
        return fieldSetMembers;
    }

    private String getLocalApiName() {
        Integer localNameIndex = this.apiName.replace('__c', '').indexOf('__');
        // Add to to the localNameIndex to compensate for the '__' part of the namespace
        return localNameIndex < 0 ? null : this.apiName.substring(localNameIndex + 2, this.apiName.length());
    }

    global virtual class FieldSetMemberMetadata {

        @AuraEnabled global final String displayType    {get; private set;}
        @AuraEnabled global final FieldMetadata field   {get; private set;}
        @AuraEnabled global final String fieldPath      {get; private set;}
        @AuraEnabled global final Boolean isDbRequired  {get; private set;}
        @AuraEnabled global final Boolean isRequired    {get; private set;}
        @AuraEnabled global final String label          {get; private set;}
        @AuraEnabled global final String sobjectApiName {get; private set;}

        private FieldSetMemberMetadata(String sobjectApiName, Schema.FieldSetMember fieldSetMember) {
            this.sobjectApiName = sobjectApiName;

            this.displayType  = fieldSetMember.getType().name();
            this.field        = this.getFieldMetadata(fieldSetMember);
            this.fieldPath    = fieldSetMember.getFieldPath();
            this.isDbRequired = fieldSetMember.getDbRequired();
            this.isRequired   = fieldSetMember.getRequired();
            this.label        = fieldSetMember.getLabel();
        }

        private FieldMetadata getFieldMetadata(Schema.FieldSetMember fieldSetMember) {
            FieldMetadata fieldMetadata;

            List<String> fieldChain = fieldSetMember.getFieldPath().split('\\.');

            if(fieldChain.size() == 0) return fieldMetadata;

            Schema.SObjectType currentFieldSObjectType = Schema.getGlobalDescribe().get(this.sobjectApiName);
            String currentFieldSObjectApiName = this.sobjectApiName;
            String currentFieldApiName;

            for(Integer i = 0; i < fieldChain.size(); i++) {
                currentFieldApiName = fieldChain[i];

                for(Schema.SObjectField sobjectField : Schema.getGlobalDescribe().get(currentFieldSObjectApiName).getDescribe().fields.getMap().values()) {
                    DescribeFieldResult fieldDescribe = sobjectField.getDescribe();

                    if(fieldDescribe.getRelationshipName() == currentFieldApiName && !fieldDescribe.getReferenceTo().isEmpty()) {
                        currentFieldSObjectType = fieldDescribe.getReferenceTo()[0];
                        currentFieldSObjectApiName = currentFieldSObjectType.getDescribe().getName();

                        break;
                    }

                }
            }

            return new FieldMetadata(currentFieldSObjectApiName, currentFieldApiName);
        }

    }

}