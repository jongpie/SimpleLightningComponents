({
    doInit : function(component, event, helper) {
        helper.handleFieldValueChanged(component, event);
        helper.getPicklistLabels(component, event);
    },
    handleFieldMetadataChanged : function(component, event, helper) {
        helper.setFieldMetadataAttributes(component, event);
        helper.getPicklistLabels(component, event);
    },
    handleRecordChanged : function(component, event, helper) {
        var record       = component.get('v.record');
        var fieldApiName = component.get('v.fieldApiName');

        component.set('v.fieldValue', record[fieldApiName]);
        helper.getPicklistLabels(component, event);
    },
    handleFieldValueChanged : function(component, event, helper) {
        helper.handleFieldValueChanged(component, event);
        helper.getPicklistLabels(component, event);
    }
})