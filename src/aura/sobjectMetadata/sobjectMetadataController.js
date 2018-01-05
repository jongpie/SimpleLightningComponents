({
    doInit : function(component, event, helper) {
        helper.fetchSObjectMetadata(component, event);
    },
    clearCachedMetadata : function(component, event, helper) {
        component.set('v.sobjectMetadata', null);
    }
})