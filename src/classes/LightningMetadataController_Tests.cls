/*****************************************************************************************************
* This file is part of the Simple Lightning Components project, released under the MIT License.      *
* See LICENSE file or go to https://github.com/jongpie/LightningComponents for full license details. *
*****************************************************************************************************/
@isTest
private class LightningMetadataController_Tests {

    @isTest
    static void it_should_return_sobject_metadata() {
        String sobjectName = 'Account';
        DescribeSObjectResult sobjectDescribe = Schema.Account.SObjectType.getDescribe();

        Test.startTest();
        LightningMetadataController.ExtendedSObjectMetadata sobjectMetadata = LightningMetadataController.getSObjectMetadata(sobjectName);
        Test.stopTest();

        System.assertEquals(sobjectName, sobjectMetadata.apiName);
        System.assertEquals(sobjectDescribe.getLabel(), sobjectMetadata.label);
        System.assertEquals(sobjectDescribe.getLabelPlural(), sobjectMetadata.labelPlural);
    }

    @isTest
    static void it_should_throw_an_exception_for_invalid_sobject() {
        String sobjectName = 'FakeObject';

        Test.startTest();
        try {
            LightningMetadataController.ExtendedSObjectMetadata sobjectMetadata = LightningMetadataController.getSObjectMetadata(sobjectName);
            System.assert(false, 'Exception expected here');
        } catch(Exception ex) {
            System.assert(ex instanceOf AuraHandledException);
        }
        Test.stopTest();
    }

    @isTest
    static void it_should_return_field_metadata() {
        String sobjectName = 'Account';
        String fieldName = 'Type';
        DescribeSObjectResult sobjectDescribe = Schema.Account.SObjectType.getDescribe();
        DescribeFieldResult fieldDescribe = Schema.Account.SObjectType.fields.Type.getDescribe();

        Test.startTest();
        LightningMetadataController.ExtendedFieldMetadata fieldMetadata = LightningMetadataController.getFieldMetadata(sobjectName, fieldName);
        Test.stopTest();

        System.assertEquals(sobjectName, fieldMetadata.sobjectApiName);
        System.assertEquals(fieldName, fieldMetadata.apiName);
        System.assertEquals(fieldDescribe.getLabel(), fieldMetadata.label);
    }

    @isTest
    static void it_should_throw_an_exception_for_invalid_field() {
        String sobjectName = 'Account';
        String fieldName = 'FakeField';

        Test.startTest();
        try {
            LightningMetadataController.ExtendedFieldMetadata fieldMetadata = LightningMetadataController.getFieldMetadata(sobjectName, fieldName);
            System.assert(false, 'Exception expected here');
        } catch(Exception ex) {
            System.assert(ex instanceOf AuraHandledException);
        }
        Test.stopTest();
    }

}