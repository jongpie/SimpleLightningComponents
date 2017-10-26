({
    fetchFieldMetadata : function(component, event) {
        var fieldName = component.get('v.fieldName');
        var action = component.get('c.getFieldMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldName': fieldName
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                var fieldMetadata = response.getReturnValue();
                component.set('v.fieldMetadata', fieldMetadata);

                if(component.get('v.displayType') == null) {
                    component.set('v.displayType', fieldMetadata.displayType);
                }
                if(component.get('v.disabled') == null) {
                    component.set('v.disabled', fieldMetadata.fieldLevelSecurity.isUpdateable == false);
                }
                if(component.get('v.required') == null) {
                    component.set('v.required', fieldMetadata.required);
                }
                this.parsePicklistOptions(component, event);
            } else {
                console.log('ERROR');
                for(var i=0; i < response.getError().length; i++) {
                   console.log(response.getError()[i]);
                }
            }
        });
        $A.enqueueAction(action);
    },
    applyInputOptionOverrides : function(component, event) {
        var inputOptions = component.get('v.inputOptions');
        component.find('uiInputField');
        //Object.assign(obj1, obj2);
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
    validateFieldValue : function(component, event) {
        var fieldRequired = component.get('v.required');

        if(fieldRequired == false) return;

        var changedField  = component.get('v.fieldName');
        var record        = component.get('v.record');
        var fieldValue    = component.get('v.fieldValue');
        var fieldMetadata = component.get('v.fieldMetadata');
        var fieldType     = component.get('v.fieldType');

        var fieldValueMissing = fieldRequired && (fieldValue == null || fieldValue == '');
        if(fieldValueMissing) {
            var inputField = component.find('inputField');
            if(inputField) inputField.set('v.errors', [{message:'The field is required'}]);
        }
    }
})