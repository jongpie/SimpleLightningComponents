({
    doInit : function(component, event, helper) {
        console.log('fieldSetMetadata.doInit');
        helper.fetchFieldSetMetadata(component, event);
    }
})