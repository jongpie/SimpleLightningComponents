/*****************************************************************************************************
* This file is part of the Simple Lightning Components project, released under the MIT License.      *
* See LICENSE file or go to https://github.com/jongpie/LightningComponents for full license details. *
*****************************************************************************************************/
public with sharing class LightningMetadataController {

    @AuraEnabled
    public static User getCurrentUser(List<String> additionalFieldApiNames) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getCurrentUser(' + additionalFieldApiNames + ')');
        try {
            List<String> userFieldNames = new List<String>{
                'DefaultCurrency', 'Email', 'FirstName', 'Id', 'Language', 'LastName', 'Locale', 'Name',
                'ProfileId', 'Username', 'UserRoleId', 'UserType'
            };

            // If there are additional fields to query, verify that the current user has access to each field
            // TODO improve this so it handles field paths for parent objects, like 'Manager.Profile.Name'
            if(additionalFieldApiNames != null) userFieldNames.addAll(additionalFieldApiNames);

            DescribeSObjectResult userDescribe = Schema.User.SObjectType.getDescribe();
            List<String> userFieldNamesToQuery = new List<String>();
            for(String fieldApiName : userFieldNames) {
                SObjectField field = userDescribe.fields.getMap().get(fieldApiName);

                if(field == null) continue;

                DescribeFieldResult fieldDescribe = field.getDescribe();
                if(fieldDescribe.isAccessible()) userFieldNamesToQuery.add(fieldApiName.toLowerCase());
            }

            // Dedupe & sort the field list
            userFieldNamesToQuery = new List<String>(new Set<String>(userFieldNamesToQuery));
            userFieldNamesToQuery.sort();

            String userQuery = 'SELECT ' + String.join(userFieldNamesToQuery, ', ')
                + ' FROM User WHERE Id = \'' + UserInfo.getUserId() + '\'';

            return (User)Database.query(userQuery);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static EnvironmentMetadata getEnvironmentMetadata() {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getEnvironmentMetadata()');
        try {
            return new EnvironmentMetadata();
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static FieldMetadata getFieldMetadataByName(String sobjectApiName, String fieldApiName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadata(\'' + sobjectApiName + '\', \'' + fieldApiName + '\')');
        try {
            return new FieldMetadata(sobjectApiName, fieldApiName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static FieldSetMetadata getFieldSetMetadataByName(String sobjectApiName, String fieldSetApiName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldSetMetadataByName(\'' + sobjectApiName + '\', \'' + fieldSetApiName + '\')');
        try {
            return new FieldSetMetadata(sobjectApiName, fieldSetApiName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static ListViewMetadata getListViewMetadataByName(String sobjectApiName, String listViewApiName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getListViewMetadata(\'' + sobjectApiName + '\', \'' + listViewApiName + '\')');
        try {
            return new ListViewMetadata(sobjectApiName, listViewApiName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static QueueMetadata getQueueMetadataById(Id queueId) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getQueueMetadataById(\'' + queueId + '\')');
        try {
            return new QueueMetadata(queueId);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static QueueMetadata getQueueMetadataByName(String queueApiName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getQueueMetadataByName(\'' + queueApiName + '\')');
        try {
            return new QueueMetadata(queueApiName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static RecordTypeMetadata getRecordTypeMetadataById(Id recordTypeId) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getRecordTypeMetadataById(\'' + recordTypeId + '\')');
        try {
            return new RecordTypeMetadata(recordTypeId);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static RecordTypeMetadata getRecordTypeMetadataByApiName(String sobjectApiName, String recordTypeApiName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getRecordTypeMetadataByApiName(\'' + sobjectApiName + '\', \'' + recordTypeApiName+ '\')');
        try {
            return new RecordTypeMetadata(sobjectApiName, recordTypeApiName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static SObjectMetadata getSObjectMetadataByName(String sobjectApiName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getSObjectMetadata(\'' + sobjectApiName + '\')');
        try {
            return new SObjectMetadata(sobjectApiName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

}