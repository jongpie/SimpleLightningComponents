({
    doInit : function(component, event, helper) {
        console.log('queuemet init');
        helper.fetchQueueMetadata(component, event);
    }
})