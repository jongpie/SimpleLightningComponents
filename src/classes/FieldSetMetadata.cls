/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class FieldSetMetadata {

    @AuraEnabled global final String ApiName                               {get; private set;}
    @AuraEnabled global final String Description                           {get; private set;}
    @AuraEnabled global final List<FieldSetMemberMetadata> FieldSetMembers {get; private set;}
    @AuraEnabled global final String Label                                 {get; private set;}
    @AuraEnabled global final String LocalApiName                          {get; private set;}
    @AuraEnabled global final String Namespace                             {get; private set;}
    @AuraEnabled global final String SobjectApiName                        {get; private set;}

    global FieldSetMetadata(String sobjectApiName, String fieldSetApiName) {
        this(Schema.getGlobalDescribe().get(sobjectApiName).getDescribe().fieldSets.getMap().get(fieldSetApiName));
    }

    global FieldSetMetadata(Schema.FieldSet fieldSet) {
        this.ApiName         = this.getApiName(fieldSet);
        this.Description     = fieldSet.getDescription();
        this.FieldSetMembers = this.getFieldSetMembers(fieldSet);
        this.Label           = fieldSet.getLabel();
        this.LocalApiName    = fieldSet.getName();
        this.Namespace       = fieldSet.getNamespace();
        this.SobjectApiName  = String.valueOf(fieldSet.getSobjectType());
    }

    private String getApiName(Schema.FieldSet fieldSet) {
        String namespace = fieldSet.getNamespace() == null ? '' : fieldSet.getNamespace() + '__';
        return namespace + fieldSet.getName();
    }

    private List<FieldSetMemberMetadata> getFieldSetMembers(Schema.FieldSet fieldSet) {
        List<FieldSetMemberMetadata> fieldSetMembers = new List<FieldSetMemberMetadata>();
        for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            FieldSetMemberMetadata fieldSetMemberMetadata = new FieldSetMemberMetadata(fieldSet.getSobjectType(), fieldSetMember);

            fieldSetMembers.add(fieldSetMemberMetadata);
        }
        fieldSetMembers.sort();
        return fieldSetMembers;
    }

    global class FieldSetMemberMetadata implements Comparable {

        @AuraEnabled global final String DisplayType    {get; private set;}
        @AuraEnabled global final FieldMetadata Field   {get; private set;}
        @AuraEnabled global final String FieldPath      {get; private set;}
        @AuraEnabled global final Boolean IsDbRequired  {get; private set;}
        @AuraEnabled global final Boolean IsRequired    {get; private set;}
        @AuraEnabled global final String Label          {get; private set;}
        @AuraEnabled global final String SobjectApiName {get; private set;}

        global Integer compareTo(Object compareTo) {
            FieldSetMemberMetadata compareToFieldSetMember = (FieldSetMemberMetadata)compareTo;

            if(this.FieldPath == compareToFieldSetMember.FieldPath) return 0;
            else if(this.FieldPath > compareToFieldSetMember.FieldPath) return 1;
            else return -1;
        }

        private FieldSetMemberMetadata(Schema.SobjectType sobjectType, Schema.FieldSetMember fieldSetMember) {
            this.DisplayType    = fieldSetMember.getType().name();
            this.Field          = this.getFieldMetadata(sobjectType, fieldSetMember);
            this.FieldPath      = fieldSetMember.getFieldPath();
            this.IsDbRequired   = fieldSetMember.getDbRequired();
            this.IsRequired     = fieldSetMember.getRequired();
            this.Label          = fieldSetMember.getLabel();
            this.SobjectApiName = String.valueOf(sobjectType);
        }

        private FieldMetadata getFieldMetadata(Schema.SobjectType sobjectType, Schema.FieldSetMember fieldSetMember) {
            FieldMetadata fieldMetadata;

            List<String> fieldChain = fieldSetMember.getFieldPath().split('\\.');

            if(fieldChain.size() == 0) return fieldMetadata;

            Schema.SobjectType currentFieldSobjectType = Schema.getGlobalDescribe().get(this.sobjectApiName);
            String currentFieldSobjectApiName = String.valueOf(sobjectType);
            String currentFieldApiName;

            for(Integer i = 0; i < fieldChain.size(); i++) {
                currentFieldApiName = fieldChain[i];

                for(Schema.SobjectField sobjectField : Schema.getGlobalDescribe().get(currentFieldSobjectApiName).getDescribe().fields.getMap().values()) {
                    DescribeFieldResult fieldDescribe = sobjectField.getDescribe();

                    if(fieldDescribe.getRelationshipName() != currentFieldApiName) continue;
                    if(fieldDescribe.getReferenceTo().isEmpty()) continue;

                    currentFieldSobjectType = fieldDescribe.getReferenceTo()[0];
                    currentFieldSobjectApiName = currentFieldSobjectType.getDescribe().getName();
                    break;
                }
            }

            return new FieldMetadata(currentFieldSobjectApiName, currentFieldApiName);
        }

    }

}