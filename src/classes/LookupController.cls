/*****************************************************************************************************
* This file is part of the Simple Lightning Components project, released under the MIT License.      *
* See LICENSE file or go to https://github.com/jongpie/LightningComponents for full license details. *
*****************************************************************************************************/
public with sharing class LookupController {

    @AuraEnabled
    public static List<MatchingRecord> search(String parentSobjectApiName, String searchFieldApiName, String searchText, String displayFieldApiName, Integer limitCount) {
        try {
            Schema.DescribeSobjectResult parentSobjectDescribe = Schema.getGlobalDescribe().get(parentSobjectApiName).getDescribe();
            SobjectMetadata parentSobjectMetadata = new SobjectMetadata(parentSobjectApiName);

            String query = 'SELECT Id, ' + displayFieldApiName + ' FROM ' + parentSobjectApiName;

            if(!String.isEmpty(searchText)) {
                searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
                query += ' WHERE ' + searchFieldApiName + ' LIKE ' + searchText;
            }

            Boolean canSortByLastViewdDate = parentSobjectDescribe.fields.getMap().containsKey('LastViewedDate') && String.isEmpty(searchText);
            String sortByField = canSortByLastViewdDate ? 'LastViewedDate DESC NULLS LAST' : parentSobjectMetadata.DisplayFieldApiName;
            query += ' ORDER BY ' + sortByField
                + ' LIMIT ' + limitCount;

            System.debug('query=' + query);

            List<MatchingRecord> searchResults = new List<MatchingRecord>();
            for(Sobject record : Database.query(query)) {
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

        Schema.SobjectType sobjectType = recordId.getSobjectType();
        SobjectMetadata sobjectMetadata = new SobjectMetadata(sobjectType);
        List<String> fields = new List<String>{'Id', sobjectMetadata.DisplayFieldApiName};

        String query = 'SELECT ' + String.join(fields, ', ')
            + ' FROM ' + sobjectMetadata.ApiName
            + ' WHERE Id = \'' + recordId + '\'';

        Sobject record = Database.query(query);
        return new MatchingRecord(record);
    }

    public class MatchingRecord {

        @AuraEnabled public Sobject Record     {get;private set;}
        @AuraEnabled public String DisplayText {get;private set;}
        @AuraEnabled public String SobjectName {get;private set;}

        public MatchingRecord(Sobject record) {
            this.record = record;

            SobjectMetadata sobjectMetadata = new SobjectMetadata(record.getSobjectType());
            this.sobjectName = sobjectMetadata.ApiName;
            this.displayText = (String)record.get(sobjectMetadata.DisplayFieldApiName);
        }

    }

}