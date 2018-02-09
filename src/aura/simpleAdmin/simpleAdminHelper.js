({
    fetchCurrentUser : function(component, event) {
        var currentUserService = component.find('currentUserService');
        currentUserService.fetch($A.getCallback(function(error, response) {
            component.set('v.currentUser', response);
        }));
    },
    fetchEnvironmentMetadata : function(component, event) {
        var environmentMetadataService = component.find('environmentMetadataService');
        environmentMetadataService.fetch($A.getCallback(function(error, response) {
            component.set('v.environmentMetadata', response);
        }));
    },
    fetchFieldMetadata : function(component, event) {
        var fieldMetadataService = component.find('fieldMetadataService');
        fieldMetadataService.fetch($A.getCallback(function(error, response) {
            component.set('v.fieldMetadata', response);
        }));
    },
    fetchListViewMetadata : function(component, event) {
        var listViewMetadataService = component.find('listViewMetadataService');
        listViewMetadataService.fetch($A.getCallback(function(error, response) {
            component.set('v.listViewMetadata', response);
        }));
    },
    fetchRecordTypeMetadata : function(component, event) {
        var recordTypeMetadataService = component.find('recordTypeMetadataService');
        recordTypeMetadataService.fetch($A.getCallback(function(error, response) {
            component.set('v.recordTypeMetadata', response);
        }));
    },
    fetchSObjectMetadata : function(component, event) {
        var sobjectMetadataService = component.find('sobjectMetadataService');
        sobjectMetadataService.fetch($A.getCallback(function(error, response) {
            component.set('v.sobjectMetadata', response);
        }));
    }
})