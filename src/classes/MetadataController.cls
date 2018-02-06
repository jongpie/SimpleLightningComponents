public with sharing class MetadataController {

    public static User getCurrentUser() {
        return getCurrentUser(null);
    }

    @AuraEnabled
    public static User getCurrentUser(List<String> fieldsToQuery) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getCurrentUserMetadata()');
        try {
            List<String> userFields = new List<String>{
                'DefaultCurrency', 'Email', 'FirstName', 'Id', 'Language', 'LastName', 'Locale', 'Name',
                'ProfileId', 'Username', 'UserRoleId', 'UserType'
            };
            // TODO add field-level security check and only add field if the current user has access
            if(fieldsToQuery != null) userFields.addAll(fieldsToQuery);

            String userQuery = 'SELECT ' + String.join(userFields, ', ') + ' FROM User WHERE Id = UserInfo.getUserId()';
            return (User)Database.query(userQuery);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static CurrentUserMetadata getCurrentUserMetadata() {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getCurrentUserMetadata()');
        try {
            return new CurrentUserMetadata();
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
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadataByName(\'' + sobjectName + '\', \'' + fieldName + '\')');
        try {
            return new FieldMetadata(sobjectName, fieldName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public static FieldMetadata getFieldMetadataByToken(Schema.SObjectType sobjectType, Schema.SObjectField field) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadataByToken(\'' + sobjectType + '\', \'' + field + '\')');
        try {
            return new FieldMetadata(sobjectType, field);
        } catch(Exception ex) {
            throw new MetadataException(ex.getMessage());
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

    public static FieldSetMetadata getFieldSetMetadataByToken(Schema.FieldSet fieldSet) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldSetMetadataByToken(\'' + fieldSet + '\')');
        try {
            return new FieldSetMetadata(fieldSet);
        } catch(Exception ex) {
            throw new MetadataException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static LimitsMetadata getLimitsMetadata() {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getLimitsMetadata()');
        try {
            return new LimitsMetadata();
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

    public static QueueMetadata getQueueMetadataByName(String queueName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getQueueMetadataByName(\'' + queueName + '\')');
        try {
            return new QueueMetadata(queueName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static ProfileMetadata getProfileMetadataById(Id profileId) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getProfileMetadataById(\'' + profileId + '\')');
        try {
            return new ProfileMetadata(profileId);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    // TODO handle overloaded methods for RecordTypeMetadata(String sobjectName, String recordTypeName)
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
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getSObjectMetadataByName(\'' + sobjectName + '\')');
        try {
            return new SObjectMetadata(sobjectName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public static SObjectMetadata getSObjectMetadataByToken(Schema.SObjectType sobjectType) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getSObjectMetadataByToken(\'' + sobjectType + '\')');
        try {
            return new SObjectMetadata(sobjectType);
        } catch(Exception ex) {
            throw new MetadataException(ex.getMessage());
        }
    }

    private class MetadataException extends Exception {}

}