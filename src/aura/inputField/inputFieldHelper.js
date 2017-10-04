({
	fetchFieldMetadata : function(component, event) {
		var action = component.get('c.getFieldMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldName': component.get('v.fieldName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                var fieldMetadata = response.getReturnValue();
                component.set('v.fieldMetadata', fieldMetadata);

                if(component.get('v.fieldType') == null) {
                    component.set('v.fieldType', fieldMetadata.fieldType);
                }

                var picklistOptions = component.get('v.picklistOptions');
                if(picklistOptions == null || component.get('v.picklistOptions').length == 0) {
                    component.set('v.picklistOptions', component.get('v.fieldMetadata').picklistOptions);
                }
            } else {
            	console.log('ERROR');
            	console.log(response.getError());
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
    }
})