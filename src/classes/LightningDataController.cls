public with sharing class LightningDataController {

    @AuraEnabled
    public static SObject createNewRecord(String sobjectName) {
        Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(sobjectName);

        SObject newRecord = sobjectType.newSObject();
        for(Schema.SObjectField field : sobjectType.getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            // Skip if the current user does not have write access to the field
            if(!fieldDescribe.isCreateable()) continue;

            newRecord.put(field, fieldDescribe.getDefaultValue());
        }

        return newRecord;
    }

    @AuraEnabled
    public static List<SObject> queryRecords(String parameterString) {
        QueryParameters parameters = (QueryParameters)JSON.deserialize(parameterString, QueryParameters.class);

        System.debug('parameters=' + parameters);

        String query = 'SELECT ' + parameters.getFieldString() + '\nFROM ' + parameters.sobjectType;

        if(parameters.filters != null) query += '\n' + parameters.filters + ' ';
        if(parameters.orderBy != null && !parameters.orderBy.isEmpty()) query += '\nORDER BY ' + String.join(parameters.orderBy, ', ');
        if(parameters.limitCount != null) query += '\nLIMIT ' + parameters.limitCount + ' ';

        System.debug('query=' + query);

        return Database.query(query);
    }

    private static List<SObject> queryRecords(List<SObject> records) {
        String sobjectName = String.valueOf(records.getSObjectType());
        Set<String> fieldNames = new Set<String>();
        Set<String> recordIdStrings = new Set<String>();
        for(SObject record : records) {
            recordIdStrings.add('\'' + record.Id + '\'');
            fieldNames.addAll(record.getPopulatedFieldsAsMap().keySet());
        }

        String joinedRecordIds ;//TODO fix this line= String.join(recordIdStrings, ', ');
        String recordFilter = 'WHERE Id IN (' + joinedRecordIds + ')';

        QueryParameters queryParameters = new QueryParameters();
        queryParameters.sobjectType = sobjectName;
        queryParameters.fields = new List<String>(fieldNames);
        queryparameters.filters = recordFilter;

        return queryRecords(JSON.serialize(queryParameters));
    }

    @AuraEnabled
    public static List<SObject> insertRecords(List<SObject> records) {
        Database.insert(records);
        return records;
    }

    @AuraEnabled
    public static List<SObject> updateRecords(List<SObject> records) {
        Database.update(records);
        records = queryRecords(records);
        return records;
    }

    @AuraEnabled
    public static List<SObject> upsertRecords(List<SObject> records) {
        Database.upsert(records);
        return records;
    }

    @AuraEnabled
    public static void deleteRecords(List<SObject> records) {
        Database.delete(records);
    }

    @AuraEnabled
    public static void hardDeleteRecords(List<SObject> records) {
        deleteRecords(records);
        Database.emptyRecycleBin(records);
    }

    @AuraEnabled
    public static List<SObject> undeleteRecords(List<SObject> records) {
        Database.undelete(records);
        return records;
    }

    private class QueryParameters {
        public String sobjectType {get;set;}
        public List<String> fields {get;set;}
        public String filters {get;set;}
        public List<String> orderBy {get;set;}
        public Integer limitCount {get;set;}

        public Boolean enforceFLS {get;set;}

        public String getFieldString() {
            if(!this.enforceFLS) return String.join(this.fields, ', ');

            Schema.SObjectType zSObjectType = Schema.getGlobalDescribe().get(this.sobjectType);
            DescribeSObjectResult zSObjectDescribe = zSObjectType.getDescribe();
            Map<String, Schema.SObjectField> zSObjectFieldMap = zSObjectDescribe.fields.getMap();

            List<String> queryableFields = new List<String>();
            for(String fieldName : this.fields) {
                Schema.SObjectField field = zSObjectFieldMap.get(fieldName);

                if(field == null) continue;
                if(!field.getDescribe().isAccessible()) continue;

                queryableFields.add(fieldName);
            }
            return String.join(queryableFields, ', ');
        }
    }

}