({
    doInit : function(component, event, helper) {
        console.log('recordTypeMetadata.doInit');
        helper.fetchRecordTypeMetadata(component, event);
    }
})