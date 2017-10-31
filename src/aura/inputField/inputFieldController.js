({
    doInit : function(component, event, helper) {
        helper.fetchSObjectMetadata(component, event);
        helper.fetchFieldMetadata(component, event);
        helper.parseFieldValue(component, event);
        helper.parsePicklistOptions(component, event);
    },
    handleRecordChanged : function(component, event, helper) {
        var record     = component.get('v.record');
        var fieldName  = component.get('v.fieldName');

        component.set('v.fieldValue', record[fieldName]);
    },
    handleFieldValueChanged : function(component, event, helper) {
        helper.handleFieldValueChanged(component, event);
    },
    handleBlur : function(component, event, helper) {
        helper.validateFieldValue(component, event)
    }
})