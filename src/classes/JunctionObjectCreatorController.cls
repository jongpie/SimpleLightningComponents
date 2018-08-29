public with sharing class JunctionObjectCreatorController {

    /*@AuraEnabled
    public static Sobject getPrimarySobjectRecord(Id recordId) {
        SobjectMetadata sobjectMetadata = new SobjectMetadata(recordId.getSobjectType());

        String query = 'SELECT Id, ' + sobjectMetadata.DisplayFieldApiName + ' FROM ' + recordId.getSobjectType() + ' WHERE Id = :recordId';
        return Database.query(query);
    }*/

    @AuraEnabled
    public static DataTableResponse getSecondarySobjectRecords(String sobjectApiName, String fieldSetApiName, String queryFilter, String orderBy, Integer limitCount, Integer offsetCount) {
        //Get the fields from FieldSet
        System.debug('sobjectApiName=' + sobjectApiName);
        System.debug('fieldSetApiName=' + fieldSetApiName);
        Schema.FieldSet fieldSet = Schema.getGlobalDescribe().get(sobjectApiName).getDescribe().fieldSets.getMap().get(fieldSetApiName);
     //   Schema.DescribeSObjectResult describeResult = sobjectType.getDescribe();
      //  Schema.FieldSet fieldSet                    = describeResult.FieldSets.getMap().get(fieldSetApiName);

        //List<sObject.records = Database.query(query);
// TODO add query logic for excludeIfExistsInJunctionObject
        return new DataTableResponse(fieldSet, queryFilter, orderBy, limitCount, offsetCount, false);
    }

    @AuraEnabled
    public static DataTableResponse createJunctionSobjectRecords(String junctionSobjectApiName, String junctionSobjectFieldSetApiName, String primarySobjectFieldApiName, String secondarySobjectFieldApiName, Id primaryRecordId, List<Id> secondaryRecordIds) {
        System.debug('junctionSobjectApiName=' + junctionSobjectApiName);
        System.debug('junctionSobjectFieldSetApiName=' + junctionSobjectFieldSetApiName);
        System.debug('primarySobjectFieldApiName=' + primarySobjectFieldApiName);
        System.debug('secondarySobjectFieldApiName=' + secondarySobjectFieldApiName);
        System.debug('primaryRecordId=' + primaryRecordId);
        System.debug('secondaryRecordIds=' + secondaryRecordIds);


Schema.SobjectType secondarySobjectType = secondaryRecordIds[0].getSobjectType();

        Schema.SobjectType junctionSobjectType = Schema.getGlobalDescribe().get(junctionSobjectApiName);
        Schema.FieldSet junctionFieldSet       = junctionSobjectType.getDescribe().fieldSets.getMap().get(junctionSobjectFieldSetApiName);
        //Schema.SobjectField primarySobjectField   = junctionSobjectType.getDescribe().fields.getMap().get(primarySobjectFieldApiName);
        SobjectMetadata secondarySobjectMetadata = new SobjectMetadata(secondarySobjectType);
        Schema.SobjectField secondarySobjectField = junctionSobjectType.getDescribe().fields.getMap().get(secondarySobjectFieldApiName);
        Map<Id, Sobject> secondaryRecordsById = new Map<Id, Sobject>(Database.query('SELECT Id, ' + secondarySobjectMetadata.DisplayFieldApiName + ' FROM ' + secondarySobjectType + ' WHERE Id IN :secondaryRecordIds'));

        List<Sobject> junctionRecords = new List<Sobject>();
        for(Id secondaryRecordId : secondaryRecordIds) {
            Sobject junctionRecord = junctionSobjectType.newSobject();

            // Primary parent object
            junctionRecord.put(primarySobjectFieldApiName, primaryRecordId);

            // Secondary parent object
            Sobject secondarySobjectParent = secondarySobjectType.newSobject();
            secondarySobjectParent.put('Id', secondaryRecordId);
            secondarySobjectParent.put(secondarySobjectMetadata.DisplayFieldApiName, secondaryRecordsById.get(secondaryRecordId).get(secondarySobjectMetadata.DisplayFieldApiName));
            secondarySobjectParent.put(secondarySobjectMetadata.DisplayFieldApiName, secondaryRecordsById.get(secondaryRecordId).get(secondarySobjectMetadata.DisplayFieldApiName));

            junctionRecord.put(secondarySobjectFieldApiName, secondaryRecordId);
            junctionRecord.putSobject(secondarySobjectField.getDescribe().getRelationshipName(), secondarySobjectParent);

            junctionRecords.add(junctionRecord);
        }
        //return junctionRecords;
        return new DataTableResponse(junctionFieldSet, junctionRecords, true);
    }

    @AuraEnabled
    public static List<Sobject> saveJunctionSobjectRecords(List<Sobject> records) {
        System.debug('new junction object records:' + records);

        insert records;
        return records;
    }

    // Verify if specific object fields are accessible
    private static Boolean checkSObjectAccessibleFSL(Schema.SobjectType sobjectType, List<String> fields) {
        Map<String,Schema.SObjectField> fieldMap = sobjecttype.getDescribe().fields.getMap();

        for(String fieldToCheck : fields) {
            if(!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        return true;
    }

    // Verify if sObject is updatable
    private static Boolean checkSObjectUpdatableFSL(String sobjectApiName, List<String> fields) {
        SObjectType sObjectType = Schema.getGlobalDescribe().get(sobjectApiName);
        Map<String,Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();

        for(String fieldToCheck : fields) {
            if(!fieldMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        return true;
    }

    public with sharing class DataTableResponse {
        @AuraEnabled public List<DataTableColumn> columns {get; private set;}
        @AuraEnabled public List<Sobject> records         {get; private set;}
        @AuraEnabled public String sobjectType            {get; private set;}
        @AuraEnabled public String displayFieldApiName    {get; private set;}
        @AuraEnabled public String tabIcon                {get; private set;}

        private Boolean editable;
        private Schema.FieldSet fieldSet;
        private String queryFilter, orderBy;
        private Integer limitCount, offsetCount;

        public DataTableResponse(Schema.FieldSet fieldSet, List<Sobject> records, Boolean editable) {
            this.editable = editable;
            this.fieldSet = fieldSet;
            this.records  = records;

            SobjectMetadata sobjectMetadata = new SobjectMetadata(fieldSet.getSobjectType());
            this.displayFieldApiName = sobjectMetadata.DisplayFieldApiName;
            this.sobjectType         = String.valueOf(fieldSet.getSobjectType());
            this.tabIcon             = sobjectMetadata.TabIcon;

            this.columns = this.getColumns();
        }

        public DataTableResponse(Schema.FieldSet fieldSet, String queryFilter, String orderBy, Integer limitCount, Integer offsetCount, Boolean editable) {
            this.editable    = editable;
            this.fieldSet    = fieldSet;
            this.queryFilter = queryFilter;
            this.orderBy     = orderBy;
            this.limitCount  = limitCount;
            this.offsetCount = offsetCount;

            this.displayFieldApiName = new SobjectMetadata(fieldSet.getSobjectType()).DisplayFieldApiName;
            this.sobjectType         = String.valueOf(fieldSet.getSobjectType());

            this.columns = this.getColumns();
            this.records = this.getRecords();
        }

        private List<DataTableColumn> getColumns() {
            List<DataTableColumn> columns = new List<DataTableColumn>();
            for(Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
                DataTableColumn column = new DataTableColumn(this.fieldSet.getSobjectType(), fieldSetMember, this.editable);
                // TODO add checks for sobject permissions & field level security permissions
                columns.add(column);
            }
            return columns;
        }

        private List<Sobject> getRecords() {
            List<String> fieldsToQuery = new List<String>();
            for(DataTableColumn column : columns) {
                fieldsToQuery.add(column.fieldName);
            }
            String query = 'SELECT ' + String.join(fieldsToQuery, ',') + ' FROM ' + this.fieldSet.getSobjectType();
            if(!String.isBlank(this.queryFilter)) query += this.queryFilter;
            if(!String.isBlank(this.orderBy)) query += this.orderBy;
            if(this.limitCount != null) query += ' LIMIT ' + this.limitCount;
            if(this.offsetCount != null) query += ' OFFSET ' + this.offsetCount;

            System.debug('query=' + query);
            return Database.query(query);
        }
    }

    public with sharing class DataTableColumn {
        @AuraEnabled public Boolean editable              {get; private set;}
        @AuraEnabled public String fieldName              {get; private set;}
        @AuraEnabled public String label                  {get; private set;}
        @AuraEnabled public String type                   {get; private set;}
        @AuraEnabled public TypeAttributes typeAttributes {get; private set;}

        private Schema.SobjectType sobjectType;

        public DataTableColumn(Schema.SobjectType sobjectType, Schema.FieldSetMember fieldSetMember, Boolean editable) {
            this.editable    = editable;
            this.sobjectType = sobjectType;
            //String dataType = String.valueOf(fieldSetMember.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            //if(dataType == 'datetime') dataType = 'date';

            this.fieldName      = fieldSetMember.getFieldPath();
            this.label          = fieldSetMember.getLabel();
            this.type           = this.getType(fieldSetMember);

            this.editable       = this.getEditable();
            this.typeAttributes = this.getTypeAttributes();
        }

        private String getType(Schema.FieldSetMember fieldSetMember) {
            String type = fieldSetMember.getType().name().toLowerCase();
            if(type == 'reference') return 'url';
            else return type;
        }

        private Boolean getEditable() {
            if(!this.editable) return false;
            // Parent field with relationship, like 'Parent.Account.Name' - parent fields are always shown as read-only
            if(this.fieldName.contains('.')) return false;
            Schema.SobjectField field = this.sobjectType.getDescribe().fields.getMap().get(this.fieldName);
            if(field == null) return false;
            return field.getDescribe().isUpdateable();
        }

        private TypeAttributes getTypeAttributes() {
            //if(this.type.toLowerCase() != 'reference') return null;
System.debug('this.fieldName=' + this.fieldName);
            //List<String> fieldPathForRelationship = this.fieldName.split('.');
            //System.debug('fieldPathForRelationship=' + fieldPathForRelationship);
            //String lastPiece = fieldPathForRelationship[fieldPathForRelationship.size()];
            //if(lastPiece.endsWith('__c')) lastPiece = lastPiece.replace('__c', '');
            //if(lastPiece.endsWith('Id')) lastPiece = lastPiece.replace('Id', '');
            String fieldPathForRelationship = this.fieldName;
            if(fieldPathForRelationship.endsWith('__c')) fieldPathForRelationship = fieldPathForRelationship.replace('__c', '__r');
            if(fieldPathForRelationship.endsWith('Id')) fieldPathForRelationship = fieldPathForRelationship.replace('Id', '');
            //fieldPathForRelationship[fieldPathForRelationship.size() - 1] = lastPiece;

            SobjectMetadata sobjectMetadata = new SobjectMetadata(this.sobjectType);
            //return new TypeAttributes(sobjectMetadata.DisplayFieldApiName, '_blank');
            //return new TypeAttributes(fieldPathForRelationship + '.Name', '_blank');
            return new TypeAttributes('Name', '_blank');
        }
    }

     public with sharing class TypeAttributes {
        @AuraEnabled public Label label   {get; private set;}
        @AuraEnabled public String target {get; private set;}

        public TypeAttributes(String labelFieldName, String target) {
            this.label  = new Label(labelFieldName);
            this.target = target;
        }
    }

    private class Label {
        @AuraEnabled String fieldName {get; private set;}

        public Label(String fieldName) {
            this.fieldName = fieldName;
        }
    }

}