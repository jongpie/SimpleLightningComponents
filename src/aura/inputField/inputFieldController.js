({
    doInit : function(component, event, helper) {
        helper.parseFieldValue(component, event);
    },
    handleFieldMetadataChanged : function(component, event, helper) {
        helper.setFieldMetadataAttributes(component, event);
    },
    handleRecordChanged : function(component, event, helper) {
        var record       = component.get('v.record');
        var fieldApiName = component.get('v.fieldApiName');

        component.set('v.fieldValue', record[fieldApiName]);
    },
    handleFieldValueChanged : function(component, event, helper) {
        helper.handleFieldValueChanged(component, event);
    },
    handleBlur : function(component, event, helper) {
        helper.validateFieldValue(component, event)
    }
})