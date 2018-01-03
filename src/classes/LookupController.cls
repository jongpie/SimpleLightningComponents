public with sharing class LookupController {

    @AuraEnabled
    public static String search(String sobjectName, String fld_API_Text, String fld_API_Val, Integer limitCount, String fld_API_Search, String searchText) {
        searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

        String query = 'SELECT ' + fld_API_Text + ', ' + fld_API_Val
            + ' FROM ' + sobjectName
            + ' WHERE ' + fld_API_Search + ' LIKE ' + searchText
            + ' ORDER BY LastViewedDate'
            + ' LIMIT ' + limitCount;
        System.debug('query=' + query);

        List<MatchingRecord> searchResults = new List<MatchingRecord>();
        for(SObject record : Database.query(query)) {
            MatchingRecord matchingRecord = new MatchingRecord();
            matchingRecord.displayText = String.valueOf(record.get(fld_API_Text));
            matchingRecord.record      = record;
            matchingRecord.recordId    = String.valueOf(record.get(fld_API_Val));
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