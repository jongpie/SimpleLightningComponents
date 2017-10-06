public with sharing class LightningDataController {

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