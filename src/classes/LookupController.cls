/*****************************************************************************************************
* This file is part of the Simple Lightning Components project, released under the MIT License.      *
* See LICENSE file or go to https://github.com/jongpie/LightningComponents for full license details. *
*****************************************************************************************************/
public with sharing class LookupController {

    @AuraEnabled
    public static List<MatchingRecord> search(String parentSObjectApiName, String searchFieldApiName, String searchText, String displayFieldApiName, Integer limitCount) {
        try {
            Schema.DescribeSObjectResult parentSObjectDescribe = Schema.getGlobalDescribe().get(parentSObjectApiName).getDescribe();
            SObjectMetadata parentSObjectMetadata = new SObjectMetadata(parentSObjectApiName);

            String query = 'SELECT Id, ' + displayFieldApiName + ' FROM ' + parentSObjectApiName;

            if(!String.isEmpty(searchText)) {
                searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
                query += ' WHERE ' + searchFieldApiName + ' LIKE ' + searchText;
            }

            Boolean canSortByLastViewdDate = parentSObjectDescribe.fields.getMap().containsKey('LastViewedDate') && String.isEmpty(searchText);
            String sortByField = canSortByLastViewdDate ? 'LastViewedDate DESC NULLS LAST' : parentSObjectMetadata.displayFieldApiName;
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
        SObjectMetadata sobjectMetadata = new SObjectMetadata(sobjectType);
        List<String> fields = new List<String>{'Id', sobjectMetadata.displayFieldApiName};

        String query = 'SELECT ' + String.join(fields, ', ')
            + ' FROM ' + sobjectMetadata.apiName
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

            SObjectMetadata sobjectMetadata = new SObjectMetadata(record.getSObjectType());
            this.sobjectName = sobjectMetadata.apiName;
            this.displayText = (String)record.get(sobjectMetadata.displayFieldApiName);
        }
    }

}