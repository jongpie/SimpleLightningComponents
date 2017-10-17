({
    doInit : function(component, event, helper) {
        helper.fetchFieldSetMetadata(component, event);
    },
    doneRendering : function(component, event, helper) {
        component.set('v.isDoneRendering', true);
    }
})