({
    setFieldMetadataAttributes : function(component, event) {
        var fieldMetadata = component.get('v.fieldMetadata');
        var record = component.get('v.record');

        // Display type
        component.set('v.displayType', fieldMetadata.DisplayType);

        // Parent record name (used for REFERENCE fields)
        var relationshipName       = fieldMetadata.RelationshipName;
        var relationshipReferences = fieldMetadata.RelationshipReferences;
        var relationshipNameField  = relationshipReferences && relationshipReferences.length > 0 ? relationshipReferences[0].nameField : null;

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
    },
    getPicklistLabels : function(component, event) {
        var fieldMetadata = component.get('v.fieldMetadata');
        var fieldApiName  = component.get('v.fieldApiName');
        var record        = component.get('v.record');

        if(fieldMetadata === null) return;
        if(fieldMetadata.DisplayType !== 'MULTIPICKLIST' && fieldMetadata.DisplayType !== 'PICKLIST') return;
        if(!record.hasOwnProperty(fieldApiName)) return;

        var picklistValues = record[fieldApiName].split(';');
        var picklistLabels = [];
        for(var i = 0; i < picklistValues.length; i++) {
            var picklistValue = picklistValues[i];

            for(var j = 0; j < fieldMetadata.PicklistOptions.length; j++) {
                var picklistOption = fieldMetadata.PicklistOptions[j];

                if(picklistOption.value !== picklistValue) continue;

                picklistLabels.push(picklistOption.label);
            }
        }
        component.set('v.fieldPicklistLabels', picklistLabels.join(';'));
    }
})