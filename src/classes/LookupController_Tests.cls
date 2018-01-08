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
        String searchResultString = LookupController.search(sobjectName, searchFieldName, searchText, displayTextFieldName, limitCount);
        List<LookupController.MatchingRecord> userResults = (List<LookupController.MatchingRecord>)JSON.deserialize(searchResultString, List<LookupController.MatchingRecord>.class);
        System.assert(userResults.size() <= limitCount);
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
        String searchResultString = LookupController.search(sobjectName, searchFieldName, searchText, displayTextFieldName, limitCount);
        List<LookupController.MatchingRecord> userResults = (List<LookupController.MatchingRecord>)JSON.deserialize(searchResultString, List<LookupController.MatchingRecord>.class);
        System.assert(userResults.size() <= limitCount);
        for(LookupController.MatchingRecord matchingRecord : userResults) {
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
            String searchResultString = LookupController.search(sobjectName, searchFieldName, searchText, displayTextFieldName, limitCount);
            System.assert(false, 'Exception expected here');
        } catch(Exception ex) {
            System.assert(ex instanceOf AuraHandledException);
        }
        Test.stopTest();
    }

}