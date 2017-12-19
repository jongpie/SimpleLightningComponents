({
    doInit : function(component, event, helper) {
        helper.handleFieldValueChanged(component, event);
    },
    handleFieldMetadataChanged : function(component, event, helper) {
        helper.setFieldMetadataAttributes(component, event);
    },
    handleRecordChanged : function(component, event, helper) {
        var record     = component.get('v.record');
        var fieldName  = component.get('v.fieldName');

        component.set('v.fieldValue', record[fieldName]);
    },
    handleFieldValueChanged : function(component, event, helper) {
        helper.handleFieldValueChanged(component, event);
    }
})