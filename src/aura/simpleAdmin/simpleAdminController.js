({
    doInit : function(component, event, helper) {
        helper.fetchEnvironmentMetadata(component, event);
        helper.fetchCurrentUser(component, event);
        helper.fetchSobjectMetadata(component, event);
    },
    fetchFieldMetadata : function(component, event, helper) {
        helper.fetchFieldMetadata(component, event);
    },
    viewFieldMetadata : function(component, event, helper) {
        component.set('v.showFieldModal', true);
    },
    fetchQueueMetadata : function(component, event, helper) {
        console.log('fetch!');
        helper.fetchQueueMetadata(component, event);
    },
    fetchRecordTypeMetadata : function(component, event, helper) {
        helper.fetchRecordTypeMetadata(component, event);
    },
    viewRecordTypeMetadata : function(component, event, helper) {
        component.set('v.showRecordTypeModal', true);
    },
    fetchSobjectMetadata : function(component, event, helper) {
        component.set('v.selectedField', null);
        component.set('v.selectedListView', null);
        component.set('v.selectedRecordType', null);
        helper.fetchSobjectMetadata(component, event);
    }
})