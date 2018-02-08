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
    fetchSObjectMetadata : function(component, event) {
        var sobjectMetadataService = component.find('sobjectMetadataService');
        sobjectMetadataService.fetch($A.getCallback(function(error, response) {
            component.set('v.sobjectMetadata', response);
        }));
    }
})