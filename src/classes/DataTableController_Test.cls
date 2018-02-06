/* Author		: Sachin Chavan
 * Date			: March 2017
 * Description	: Test Class for Lightning Data Table Component.
 */
@isTest
private class DataTableController_Test {

    @testSetup
    static void setupTestData() {
        List<Account> accountToBeInsertList = new List<Account>();
        for(Integer iIndex = 1; iIndex <= 100; iIndex++) {
            Account accountNew = new Account();
            accountNew.Name = 'Test Account - ' + iIndex;
            accountNew.Website = 'www.cognizant.com';
            accountNew.Phone = '9876543210';
            
            accountToBeInsertList.add(accountNew);
        }
        
        insert accountToBeInsertList;
    }
    
    @isTest
    static void dataTableFunctionalityTest() {
        List<String> fields = new List<String>();
        fields.add('Name');
        fields.add('Website');
        fields.add('Phone');
        
        String dataColumnJSONString = DataTableController.initComponent('Account', fields);
        List<Object> dataColumnList = (List<Object>) JSON.deserializeUntyped(dataColumnJSONString);
        System.assertEquals(3, dataColumnList.size());
        
        String recordsJSONString = DataTableController.fetchRecords('Account', fields, 'Test', 'Name', 'ASC', 25);
        List<Object> recordList = (List<Object>) JSON.deserializeUntyped(recordsJSONString);
        System.assertEquals(25, recordList.size());
    }
    
}