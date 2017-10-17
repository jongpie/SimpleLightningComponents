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

                if(component.get('v.displayType') == null) {
                    component.set('v.displayType', fieldMetadata.displayType);
                }
                this.parsePicklistOptions(component, event);
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
    },
    parsePicklistOptions : function(component, event) {
        var fieldValue = component.get('v.fieldValue');
        var picklistOptions = component.get('v.picklistOptions');
        console.log(component.get('v.fieldMetadata'));
        if(component.get('v.fieldType') =='PICKLIST') {
            console.log('start parsePicklistOptions');
            console.log('picklistOptions');
            for(var i=0; i < picklistOptions.length; i++) {
                console.log(picklistOptions[i]);
            }
        }
        if(picklistOptions == null || picklistOptions.length == 0) {
            console.log('adding field fieldMetadata picklistOptions');
            var fieldMetadata = component.get('v.fieldMetadata');

            if(fieldMetadata == null) return;

            picklistOptions = fieldMetadata.picklistOptions;
        }
        for(var i=0; i < picklistOptions.length; i++) {
            var picklistOption = picklistOptions[i];
            console.log('fieldValue');
            console.log(fieldValue);
            picklistOption.isSelectedValue = fieldValue == picklistOption.picklistValue;
        }
        component.set('v.picklistOptions', picklistOptions);
    },
})