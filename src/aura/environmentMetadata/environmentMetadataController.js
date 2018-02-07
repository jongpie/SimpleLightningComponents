({
    doInit : function(component, event, helper) {
        console.log('environmentMetadata.doInit');
        helper.fetchEnvironmentMetadata(component, event);
    }
})