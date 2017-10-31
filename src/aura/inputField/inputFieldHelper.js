({
    fetchSObjectMetadata : function(component, event) {
        var action = component.get('c.getSObjectMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var sobjectMetadata = response.getReturnValue();
                component.set('v.sobjectMetadata', sobjectMetadata);
            } else {
                console.log(response.getError().length + ' ERRORS');
                for(var i = 0; i < response.getError().length; i++) {
                   console.log(response.getError()[i]);
                }
            }
        });
        $A.enqueueAction(action);
    },
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
                this.parsePicklistOptions(component, event);
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
    parsePicklistOptions : function(component, event) {
        var fieldValue = component.get('v.fieldValue');
        var picklistOptions = component.get('v.picklistOptions');

        if(picklistOptions == null || picklistOptions.length == 0) {
            var fieldMetadata = component.get('v.fieldMetadata');

            if(fieldMetadata == null) return;

            picklistOptions = fieldMetadata.picklistOptions;
        }
        component.set('v.picklistOptions', picklistOptions);
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
            this.parsePicklistOptions(component, event);
        }
    },
    validateFieldValue : function(component, event) {
        if(component.get('v.required') == false) return;

        var fieldValue    = component.get('v.fieldValue');

        var fieldValueMissing = fieldValue == null || fieldValue == '' || fieldValue == undefined;
        if(fieldValueMissing) {
            var inputField = component.find('inputField');
            if(inputField) inputField.set('v.errors', [{message:'This field is required'}]);
        }
    }
})