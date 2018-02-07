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
    public static ExtendedFieldMetadata getFieldMetadataByName(String sobjectName, String fieldName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadata(\'' + sobjectName + '\', \'' + fieldName + '\')');
        try {
            return new ExtendedFieldMetadata(sobjectName, fieldName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<ExtendedFieldMetadata> getFieldMetadataByNames(String sobjectName, List<String> fieldNames) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadataByNames(\'' + sobjectName + '\', \'' + fieldNames + '\')');
        try {
            List<ExtendedFieldMetadata> results = new List<ExtendedFieldMetadata>();
            for(String fieldName : fieldNames) {
                results.add(new ExtendedFieldMetadata(sobjectName, fieldName));
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
    public static ExtendedSObjectMetadata getSObjectMetadataByName(String sobjectName) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getSObjectMetadata(\'' + sobjectName + '\')');
        try {
            return new ExtendedSObjectMetadata(sobjectName);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<ExtendedSObjectMetadata> getSObjectMetadataByNames(List<String> sobjectNames) {
        System.debug(LoggingLevel.INFO, 'Executing LightningMetadataController.getFieldMetadataByNames(\'' + sobjectNames + '\')');
        try {
            List<ExtendedSObjectMetadata> results = new List<ExtendedSObjectMetadata>();
            for(String sobjectName : sobjectNames) {
                results.add(new ExtendedSObjectMetadata(sobjectName));
            }
            return results;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public class ExtendedSObjectMetadata extends SObjectMetadata {
        // TODO finish implementing
        //@AuraEnabled public final List<RecordTypeMetadata> recordTypes {get; private set;}
        private ExtendedSObjectMetadata(String sobjectName) {
            super(sobjectName);
            //this.recordTypes = this.getRecordTypes();
        }

        private List<RecordTypeMetadata> getRecordTypes() {
            List<RecordTypeMetadata> recordTypes = new List<RecordTypeMetadata>();
            for(String recordTypeApiName : RecordTypeMetadata.getRecordTypeApiNames(this.apiName)) {
                recordTypes.add(new RecordTypeMetadata(this.apiName, recordTypeApiName));
            }
            return recordTypes;
        }
    }

    public class ExtendedFieldMetadata extends FieldMetadata {
        // TODO consider moving to SimpleMetadata project instead
        @AuraEnabled public final SObjectMetadata sobjectMetadata {get; private set;}
        private ExtendedFieldMetadata(String sobjectName, String fieldName) {
            super(sobjectName, fieldName);
            this.sobjectMetadata = new SObjectMetadata(sobjectName);
        }
    }

}