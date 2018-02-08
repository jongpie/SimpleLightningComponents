({
    doInit : function(component, event, helper) {
        helper.fetchEnvironmentMetadata(component, event);
        helper.fetchCurrentUser(component, event);
        helper.fetchSObjectMetadata(component, event);
    },
    fetchFieldMetadata : function(component, event, helper) {
        helper.fetchFieldMetadata(component, event);
    },
    viewFieldMetadata : function(component, event, helper) {
        component.set('v.showFieldModal', true);
    },
    fetchRecordTypeMetadata : function(component, event, helper) {
        helper.fetchRecordTypeMetadata(component, event);
    },
    viewRecordTypeMetadata : function(component, event, helper) {
        component.set('v.showRecordTypeModal', true);
    },
    fetchSObjectMetadata : function(component, event, helper) {
        component.set('v.selectedField', null);
        helper.fetchSObjectMetadata(component, event);
    }
})