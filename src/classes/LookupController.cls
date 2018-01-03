public with sharing class LookupController {

    @AuraEnabled
    public static String search(String sobjectName, String searchFieldName, String searchText, String displayTextFieldName, Integer limitCount) {
        searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

        String query = 'SELECT Id, ' + displayTextFieldName // + ', ' + fieldName
            + ' FROM ' + sobjectName
            + ' WHERE ' + searchFieldName + ' LIKE ' + searchText
            + ' ORDER BY LastViewedDate'
            + ' LIMIT ' + limitCount;
        System.debug('query=' + query);

        List<MatchingRecord> searchResults = new List<MatchingRecord>();
        for(SObject record : Database.query(query)) {
            MatchingRecord matchingRecord = new MatchingRecord();
            matchingRecord.displayText = String.valueOf(record.get(displayTextFieldName));
            matchingRecord.record      = record;
            matchingRecord.recordId    = String.valueOf(record.get('Id'));
            matchingRecord.sobjectName = sobjectName;
            searchResults.add(matchingRecord);
        }

        return JSON.serialize(searchResults);
    }

    public class MatchingRecord {
        public SObject record     {get;set;}
        public String displayText {get;set;}
        public String recordId    {get;set;}
        public String sobjectName {get;set;}
    }

}