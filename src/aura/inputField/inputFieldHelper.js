({
    cachedResults : {},
    setFieldMetadataAttributes : function(component, event) {
        var fieldMetadata = component.get('v.fieldMetadata');

        if(component.get('v.displayType') === undefined) {
            component.set('v.displayType', fieldMetadata.DisplayType);
        }
        if(component.get('v.disabled') === undefined) {
            component.set('v.disabled', fieldMetadata.IsUpdateable == false);
        }
        if(component.get('v.required') === undefined) {
            var isUpdateableRequired = fieldMetadata.IsUpdateable && fieldMetadata.IsRequired;
            var isUpdateableNameField = fieldMetadata.IsUpdateable && fieldMetadata.IsNameField;
            component.set('v.required', isUpdateableRequired || isUpdateableNameField);
        }
        this.parsePicklistOptions(component, event);
    },
    parseFieldValue : function(component, event) {
        var record = component.get('v.record');
        var fieldApiName = component.get('v.fieldApiName');
        if(record === null) return;

        if(record.hasOwnProperty(fieldApiName)) {
            component.set('v.fieldValue', record[fieldApiName]);
        }
    },
    parsePicklistOptions : function(component, event) {
        var fieldValue = component.get('v.fieldValue');
        var picklistOptions = component.get('v.picklistOptions');

        if(picklistOptions === undefined || picklistOptions === null || picklistOptions.length === 0) {
            var fieldMetadata = component.get('v.fieldMetadata');

            if(fieldMetadata == null) return;

            picklistOptions = fieldMetadata.PicklistOptions;
        }
        component.set('v.picklistOptions', picklistOptions);
    },
    handleFieldValueChanged : function(component, event) {
        var changedField  = component.get('v.fieldApiName');
        var record        = component.get('v.record');
        var fieldValue    = component.get('v.fieldValue');
        var fieldMetadata = component.get('v.fieldMetadata');
        var displayType   = component.get('v.displayType');

        var newFieldValue = event.getParam('value') !== undefined ? event.getParam('value') : event.getSource().get('v.value');
        if(typeof newFieldValue === 'undefined') newFieldValue = '';
        var oldFieldValue = event.getParam('oldValue') !== undefined ? event.getParam('oldValue') : event.getSource().get('v.oldValue');

        var fieldChanged = newFieldValue !== oldFieldValue;
        // If the displayType is different from the field metadata and it should be a string, then cast to strings and compare to see if the field changed
        if(newFieldValue !== null && typeof newFieldValue !== 'string' && fieldMetadata != null && (fieldMetadata.DisplayType === 'TEXT' || fieldMetadata.DisplayType === 'TEXTAREA')) {
            var newFieldValueString = newFieldValue == null ? null : newFieldValue.toString();
            var oldFieldValueString = oldFieldValue == null ? null : oldFieldValue.toString();
            fieldChanged = newFieldValueString !== oldFieldValueString;
        }

        if(fieldChanged) {
            if(newFieldValue !== null && typeof newFieldValue !== 'string' && fieldMetadata != null && (fieldMetadata.DisplayType === 'TEXT' || fieldMetadata.DisplayType === 'TEXTAREA')) {
                newFieldValue = newFieldValue.toString();
            }
            record[changedField] = newFieldValue;
            component.set('v.record', record);
            this.parsePicklistOptions(component, event);
        }
    },
    validateFieldValue : function(component, event) {
        var fieldRequired   = component.get('v.required');
        var fieldValue = component.get('v.fieldValue');

        var fieldValueMissing = fieldValue === null || fieldValue === '' || fieldValue === undefined;
        var errorMessage = (fieldRequired && fieldValueMissing) ? [{message:'This field is required'}] : null;
        var inputField = component.find('inputField');
        if(inputField) inputField.set('v.errors', errorMessage);
    }
})