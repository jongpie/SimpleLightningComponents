/*****************************************************************************************************
* This file is part of the Simple Lightning Components project, released under the MIT License.      *
* See LICENSE file or go to https://github.com/jongpie/LightningComponents for full license details. *
*****************************************************************************************************/
@isTest
private class LookupController_Tests {

    @isTest
    static void it_should_return_results_when_no_search_term_provided() {
        String sobjectName          = 'User';
        String searchFieldName      = 'Name';
        String searchText           = null;
        String displayTextFieldName = 'Name';
        Integer limitCount          = 10;

        Test.startTest();
        List<LookupController.MatchingRecord> searchResults = LookupController.search(sobjectName, searchFieldName, searchText, displayTextFieldName, limitCount);
        System.assert(searchResults.size() <= limitCount);
        Test.stopTest();
    }

    @isTest
    static void it_should_return_results_when_search_term_provided() {
        User currentUser = [SELECT Id, FirstName, LastName, Name FROM User WHERE Id = :UserInfo.getUserId()];

        String sobjectName          = 'User';
        String searchFieldName      = 'Name';
        String searchText           = currentUser.LastName;
        String displayTextFieldName = 'Name';
        Integer limitCount          = 10;

        Test.startTest();
        List<LookupController.MatchingRecord> searchResults = LookupController.search(sobjectName, searchFieldName, searchText, displayTextFieldName, limitCount);
        System.assert(searchResults.size() <= limitCount);
        for(LookupController.MatchingRecord matchingRecord : searchResults) {
            String recordName = (String)matchingRecord.record.get('Name');
            System.assert(recordName.contains(searchText));
        }
        Test.stopTest();
    }

    @isTest
    static void it_should_throw_an_exception_for_invalid_sobject() {
        String sobjectName          = 'FakeObject';
        String searchFieldName      = 'Name';
        String searchText           = null;
        String displayTextFieldName = 'Name';
        Integer limitCount          = 10;

        Test.startTest();
        try {
            List<LookupController.MatchingRecord> searchResults = LookupController.search(sobjectName, searchFieldName, searchText, displayTextFieldName, limitCount);
            System.assert(false, 'Exception expected here');
        } catch(Exception ex) {
            System.assert(ex instanceOf AuraHandledException);
        }
        Test.stopTest();
    }

    @isTest
    static void it_should_return_record_based_on_record_id() {
        Id myUserId = UserInfo.getUserId();

        Test.startTest();
        LookupController.MatchingRecord recordMatch = LookupController.getRecord(myUserId);
        System.assertEquals(myUserId, recordMatch.record.Id);
        Test.stopTest();
    }

    @isTest
    static void it_should_return_null_when_record_id_is_null() {
        Test.startTest();
        LookupController.MatchingRecord recordMatch = LookupController.getRecord(null);
        System.assertEquals(null, recordMatch);
        Test.stopTest();
    }

}