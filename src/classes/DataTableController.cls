/* Author		: Sachin Chavan
 * Date			: March 2017
 * Description	: Apex Controller for Lightning Data Table Component.
 */
public without sharing class DataTableController {

    @AuraEnabled
    public static String initComponent(String objectType, List<String> fields) {
        List<Object> fieldList = new List<Object>();
        
        Map<String,Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        if(globalDescribeMap.containsKey(objectType)) {
            Schema.DescribeSObjectResult sobjectDescribeResult = globalDescribeMap.get(objectType).getDescribe();
            Map<String,Schema.SObjectField> fieldMap = sobjectDescribeResult.fields.getMap();
            for(String field : fields) {
                if(fieldMap.containsKey(field)) {
                    Schema.DescribeFieldResult fieldResult = fieldMap.get(field).getDescribe();
                    DataColumn dataColumnNew = new DataColumn(fieldResult.getLabel(), fieldResult.getName());
                    fieldList.add(dataColumnNew);
                }
            }
        }
        
        return JSON.serialize(fieldList);
    }
    
    @AuraEnabled
    public static String fetchRecords(String objectType, List<String> fields, String keyword, String sortField, String sortDir, Integer iLimit) {
        String query = 'SELECT ' + String.join(fields, ', ') + ' FROM ' + objectType;
        
        if(String.isNotBlank(keyword)) {
            query += ' WHERE Name LIKE \'%' + keyword + '%\'';
        }
        
        if(String.isNotBlank(sortField) && String.isNotBlank(sortDir)) {
        	query += ' ORDER BY ' + sortField + ' ' + sortDir;
        }
        
        query += '  LIMIT ' + iLimit;
        List<SObject> recordList = Database.query(query);
        
        return JSON.serialize(recordList);
    }
    
    public class DataColumn {
        public String label { get; set; }
        public String name { get; set; }
        
        public DataColumn(String label, String name) {
            this.label = label;
            this.name = name;
        }
    }
}