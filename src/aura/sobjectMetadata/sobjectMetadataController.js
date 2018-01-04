({
    doInit : function(component, event, helper) {
        console.log('sobjectMetadata init');
        helper.fetchSObjectMetadata(component, event);
    }
})