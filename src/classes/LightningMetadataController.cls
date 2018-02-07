/*****************************************************************************************************
* This file is part of the Simple Lightning Components project, released under the MIT License.      *
* See LICENSE file or go to https://github.com/jongpie/LightningComponents for full license details. *
*****************************************************************************************************/
public with sharing class LightningMetadataController {

    @AuraEnabled
    public static User getCurrentUser(List<String> additionalfieldNames) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getCurrentUser(' + additionalfieldNames + ')');
        try {
            List<String> userFieldNames = new List<String>{
                'DefaultCurrency', 'Email', 'FirstName', 'Id', 'Language', 'LastName', 'Locale', 'Name',
                'ProfileId', 'Username', 'UserRoleId', 'UserType'
            };

            // If there are additional fields to query, verify that the current user has access to each field
            // TODO improve this so it handles field paths for parent objects, like 'Manager.Profile.Name'
            if(additionalfieldNames != null) userFieldNames.addAll(additionalfieldNames);

            DescribeSObjectResult userDescribe = Schema.User.SObjectType.getDescribe();
            List<String> userFieldNamesToQuery = new List<String>();
            for(String fieldName : userFieldNames) {
                SObjectField field = userDescribe.fields.getMap().get(fieldName);

                if(field == null) continue;

                DescribeFieldResult fieldDescribe = field.getDescribe();
                if(fieldDescribe.isAccessible()) userFieldNamesToQuery.add(fieldName.toLowerCase());
            }

            // Dedupe the field list
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
    public static FieldMetadata getFieldMetadataByName(String sobjectName, String fieldName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadata(\'' + sobjectName + '\', \'' + fieldName + '\')');
        try {
            return new FieldMetadata(sobjectName, fieldName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<FieldMetadata> getFieldMetadataByNames(String sobjectName, List<String> fieldNames) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadataByNames(\'' + sobjectName + '\', \'' + fieldNames + '\')');
        try {
            List<FieldMetadata> results = new List<FieldMetadata>();
            for(String fieldName : fieldNames) {
                results.add(new FieldMetadata(sobjectName, fieldName));
            }
            return results;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static FieldSetMetadata getFieldSetMetadataByName(String sobjectName, String fieldSetName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldSetMetadataByName(\'' + sobjectName + '\', \'' + fieldSetName + '\')');
        try {
            return new FieldSetMetadata(sobjectName, fieldSetName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static ListViewMetadata getListViewMetadataByName(String sobjectName, String listViewName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getListViewMetadata(\'' + sobjectName + '\', \'' + listViewName + '\')');
        try {
            return new ListViewMetadata(sobjectName, listViewName);
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
    public static RecordTypeMetadata getRecordTypeMetadataById(Id recordTypeId) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getRecordTypeMetadataById(\'' + recordTypeId + '\')');
        try {
            return new RecordTypeMetadata(recordTypeId);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static SObjectMetadata getSObjectMetadataByName(String sobjectName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getSObjectMetadata(\'' + sobjectName + '\')');
        try {
            return new SObjectMetadata(sobjectName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<SObjectMetadata> getSObjectMetadataByNames(List<String> sobjectNames) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadataByNames(\'' + sobjectNames + '\')');
        try {
            List<SObjectMetadata> results = new List<SObjectMetadata>();
            for(String sobjectName : sobjectNames) {
                results.add(new SObjectMetadata(sobjectName));
            }
            return results;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

}