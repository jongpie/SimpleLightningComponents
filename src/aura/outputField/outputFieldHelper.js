({
    fetchFieldMetadata : function(component, event) {
        var action = component.get('c.getFieldMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldName': component.get('v.fieldName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var fieldMetadata = response.getReturnValue();
                component.set('v.fieldMetadata', fieldMetadata);

                if(component.get('v.displayType') === undefined) {
                    component.set('v.displayType', fieldMetadata.displayType);
                }
            } else {
                console.log(response.getError().length + ' ERRORS');
                for(var i = 0; i < response.getError().length; i++) {
                   console.log(response.getError()[i]);
                }
            }
        });
        $A.enqueueAction(action);
    },
    parseFieldValue : function(component, event) {
        var record = component.get('v.record');
        var fieldName = component.get('v.fieldName');

        if(record == null) return;
        if(record.hasOwnProperty(fieldName)) {
            component.set('v.fieldValue', record[fieldName]);
        }
    },
    handleFieldValueChanged : function(component, event) {
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