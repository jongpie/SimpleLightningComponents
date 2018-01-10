
public with sharing class LookupController {

    @AuraEnabled
    public static List<MatchingRecord> search(String parentSObjectName, String searchFieldName, String searchText, String displayTextFieldName, Integer limitCount) {
        try {
            Schema.DescribeSObjectResult parentSObjectDescribe = Schema.getGlobalDescribe().get(parentSObjectName).getDescribe();
            LightningMetadataController.SObjectMetadata parentSObjectMetadata = new LightningMetadataController.SObjectMetadata(parentSObjectName);

            String query = 'SELECT Id, ' + displayTextFieldName
                + ' FROM ' + parentSObjectName;

            if(!String.isEmpty(searchText)) {
                searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
                query += ' WHERE ' + searchFieldName + ' LIKE ' + searchText;
            }

            String sortByField = parentSObjectDescribe.fields.getMap().containsKey('LastViewedDate') ? 'LastViewedDate DESC NULLS LAST' : parentSObjectMetadata.nameField;
            query += ' ORDER BY ' + sortByField
                + ' LIMIT ' + limitCount;

            System.debug('query=' + query);

            List<MatchingRecord> searchResults = new List<MatchingRecord>();
            for(SObject record : Database.query(query)) {
                MatchingRecord matchingRecord = new MatchingRecord(record);
                searchResults.add(matchingRecord);
            }

            //System.debug(JSON.serialize(searchResults));
            return searchResults;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static MatchingRecord getRecord(Id recordId) {
        if(recordId == null) return null;

        Schema.SObjectType sobjectType = recordId.getSObjectType();
        LightningMetadataController.SObjectMetadata sobjectMetadata = new LightningMetadataController.SObjectMetadata(sobjectType);
        List<String> fields = new List<String>{'Id', sobjectMetadata.nameField};

        String query = 'SELECT ' + String.join(fields, ', ')
            + ' FROM ' + sobjectMetadata.name
            + ' WHERE Id = \'' + recordId + '\'';

        SObject record = Database.query(query);
        return new MatchingRecord(record);
    }

    public class MatchingRecord {
        @AuraEnabled public SObject record     {get;private set;}
        @AuraEnabled public String displayText {get;private set;}
        @AuraEnabled public String sobjectName {get;private set;}

        public MatchingRecord(SObject record) {
            this.record = record;

            LightningMetadataController.SObjectMetadata sobjectMetadata = new LightningMetadataController.SObjectMetadata(record.getSObjectType());
            this.sobjectName = sobjectMetadata.name;
            this.displayText = (String)record.get(sobjectMetadata.nameField);
        }
    }

}