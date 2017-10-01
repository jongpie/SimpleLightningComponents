({
    doInit : function(component, event, helper) {
        var record = component.get('v.record');
        console.log('record');
        console.log(record);
        var fieldValue = component.get('v.fieldValue');
        console.log(fieldValue);
        if(record != null) component.set('v.fieldValue', record[fieldValue]);
        helper.fetchFieldMetadata(component, event);
        helper.parseFieldValue(component, event);
    },
    handleRecordChanged : function(component, event, helper) {
        var record     = component.get("v.record");
        var fieldName  = component.get("v.fieldName");

        var fieldValue = record[fieldName];
        component.set("v.fieldValue", fieldValue);
    },
    handleFieldValueChanged : function(component, event, helper) {
        console.log('handleFieldValueChanged');
        var changedField = component.get('v.fieldName');
        var record = component.get('v.record');

        console.log('field changed: ' + changedField);

        if(record[changedField] == undefined) {
            console.log('not added');
            record['"' + changedField + '"'] = component.get('v.fieldMetadata').fieldDefaultValue;
        }
        // Get the old and new values so we can update the SObject record
        // Most fields will use event.getParam("value")
        // Some fields, like picklists, will use event.getSource().get("v.value")
        // TODO verify that this can't be simplified
        var newFieldValue = event.getParam("value") != undefined ? event.getParam("value") : event.getSource().get("v.value");
        var oldFieldValue = event.getParam("oldValue") != undefined ? event.getParam("oldValue") : event.getSource().get("v.oldValue");

        // If the value of the field changed, then update the record
        if(newFieldValue != oldFieldValue) {
            // Set the field's new value on our copy of the record
            record[changedField] = newFieldValue;
            // Set the record to be our version of the record with the new field value
            // All other Lightning components will be notified of the change to the record
            component.set("v.record", record);
            console.log('record');
            console.log(component.get("v.record"));
        }
    }
})