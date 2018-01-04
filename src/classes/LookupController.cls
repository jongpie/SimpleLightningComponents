public with sharing class LookupController {

    @AuraEnabled
    public static String search(String parentSObjectName, String searchFieldName, String searchText, String displayTextFieldName, Integer limitCount) {
        String query = 'SELECT Id, ' + displayTextFieldName
            + ' FROM ' + parentSObjectName;

        if(searchText != null) {
            searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
            query += ' WHERE ' + searchFieldName + ' LIKE ' + searchText;
        }

        query += ' ORDER BY LastViewedDate'
            + ' LIMIT ' + limitCount;

        System.debug('query=' + query);

        List<MatchingRecord> searchResults = new List<MatchingRecord>();
        for(SObject record : Database.query(query)) {
            MatchingRecord matchingRecord = new MatchingRecord();
            matchingRecord.displayText = String.valueOf(record.get(displayTextFieldName));
            matchingRecord.record      = record;
            matchingRecord.sobjectName = parentSObjectName;
            searchResults.add(matchingRecord);
        }

        System.debug(JSON.serialize(searchResults));
        return JSON.serialize(searchResults);
    }

    public class MatchingRecord {
        public SObject record     {get;set;}
        public String displayText {get;set;}
        public String sobjectName {get;set;}
    }

}