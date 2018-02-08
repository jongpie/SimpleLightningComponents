({
    doInit : function(component, event, helper) {
        helper.fetchEnvironmentMetadata(component, event);
        helper.fetchCurrentUser(component, event);
        helper.fetchSObjectMetadata(component, event);
    },
    fetchSObjectMetadata : function(component, event, helper) {
        helper.fetchSObjectMetadata(component, event);
    }
})