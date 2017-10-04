({
    doInit : function(component, event, helper) {
        helper.fetchFieldMetadata(component, event);
        helper.parseFieldValue(component, event);
    },
    handleRecordChanged : function(component, event, helper) {
        var record     = component.get('v.record');
        var fieldName  = component.get('v.fieldName');

        component.set('v.fieldValue', record[fieldName]);
    },
    handleFieldValueChanged : function(component, event, helper) {
        var changedField  = component.get('v.fieldName');
        var record        = component.get('v.record');
        var fieldValue    = component.get('v.fieldValue');
        var fieldMetadata = component.get('v.fieldMetadata');
        var fieldType     = component.get('v.fieldType');

        var newFieldValue = event.getParam('value') != undefined ? event.getParam('value') : event.getSource().get('v.value');
        if(typeof newFieldValue == 'undefined') newFieldValue = '';
        var oldFieldValue = event.getParam('oldValue') != undefined ? event.getParam('oldValue') : event.getSource().get('v.oldValue');

        if(newFieldValue != oldFieldValue) {
            if(fieldMetadata != null && fieldType != fieldMetadata.fieldType && typeof fieldType == 'string') {
                newFieldValue = newFieldValue.toString();
            }

            record[changedField] = newFieldValue;
            component.set('v.record', record);
        }
    }
})