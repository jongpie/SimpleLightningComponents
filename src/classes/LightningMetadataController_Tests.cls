@isTest
private class LightningMetadataController_Tests {

    @isTest
    static void getSObjectMetadataTest() {
        String sobjectName = 'Account';
        DescribeSObjectResult sobjectDescribe = Schema.Account.SObjectType.getDescribe();

        Test.startTest();
        LightningMetadataController.SObjectMetadata sobjectMetadata = LightningMetadataController.getSObjectMetadata(sobjectName);
        Test.stopTest();

        System.assertEquals(sobjectName, sobjectMetadata.name);
        System.assertEquals(sobjectDescribe.getLabel(), sobjectMetadata.label);
        System.assertEquals(sobjectDescribe.getLabelPlural(), sobjectMetadata.labelPlural);
    }

    @isTest
    static void getFieldMetadataTest() {
        String sobjectName = 'Account';
        String fieldName = 'Type';
        DescribeSObjectResult sobjectDescribe = Schema.Account.SObjectType.getDescribe();
        DescribeFieldResult fieldDescribe = Schema.Account.SObjectType.fields.Type.getDescribe();

        Test.startTest();
        LightningMetadataController.FieldMetadata fieldMetadata = LightningMetadataController.getFieldMetadata(sobjectName, fieldName);
        Test.stopTest();

        System.assertEquals(sobjectName, fieldMetadata.sobjectName);
        System.assertEquals(fieldName, fieldMetadata.name);
        System.assertEquals(fieldDescribe.getLabel(), fieldMetadata.label);
    }

}