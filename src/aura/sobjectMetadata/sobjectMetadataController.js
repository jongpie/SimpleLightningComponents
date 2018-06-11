({
    doInit : function(component, event, helper) {
        helper.fetchSobjectMetadata(component, event);
    },
    clearCachedMetadata : function(component, event, helper) {
        component.set('v.sobjectMetadata', null);
    }
})