({
    setFieldMetadataAttributes : function(component, event) {
        var fieldMetadata = component.get('v.fieldMetadata');
        var record = component.get('v.record');

        // Display type
        component.set('v.displayType', fieldMetadata.displayType);

        // Parent record name (used for REFERENCE fields)
        var relationshipName = fieldMetadata.relationshipName;
        var relationshipReferences = fieldMetadata.relationshipReferences;
        var relationshipNameField = relationshipReferences && relationshipReferences.length > 0 ? relationshipReferences[0].nameField : null;

        if(record && record.hasOwnProperty(relationshipName)) {
            var parentRecord = record[relationshipName];

            if(parentRecord.hasOwnProperty(relationshipNameField)) {
                var parentRecordName = parentRecord[relationshipNameField];
                component.set('v.parentRecordName', parentRecordName);
            }
        }
    },
    handleFieldValueChanged : function(component, event) {
        var record = component.get('v.record');
        var fieldApiName = component.get('v.fieldApiName');

        if(record === null) return;

        if(record.hasOwnProperty(fieldApiName)) {
            component.set('v.fieldValue', record[fieldApiName]);
        }
    }
})