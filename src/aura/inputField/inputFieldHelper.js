({
	fetchFieldMetadata : function(component, event) {
		var action = component.get("c.getFieldMetadata");
        action.setParams({
            "sobjectName": component.get("v.sobjectName"),
            "fieldName": component.get("v.fieldName")
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
            	console.log('fieldMetadata');
            	console.log(response.getReturnValue());
            	component.set('v.fieldMetadata', response.getReturnValue());

            	this.setPicklistOptions(component, event);
            } else {
            	console.log('ERROR');
            	console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    parseFieldValue : function(component, event) {
    	var record = component.get('v.record');
    	if(record == null) return;

    	component.set('v.fieldValue', record[fieldValue]);
    },
    setPicklistOptions : function(component, event) {
    	if(component.get('v.fieldMetadata.fieldType') != 'PICKLIST') return;

    	// if(component.get('v.required') == undefined) {
     //        component.set('v.required', response.getReturnValue().fieldRequired);
     //    }
     //    var allValues = response.getReturnValue().picklistOptions;

     //    // TODO: switch to using this
     //    if (allValues != undefined && allValues.length > 0) {
     //        opts.push({
     //            class: "optionClass",
     //            label: "--- None ---",
     //            value: ""
     //        });
     //    }
     //    for (var i = 0; i < allValues.length; i++) {
     //        opts.push({
     //            class: "optionClass",
     //            label: allValues[i],
     //            value: allValues[i]
     //        });
     //    }
     //    var auraId = component.get('v.auraId');
     //    console.log(auraId);
     //    console.log(component.find('"' + auraId + '"'));
     //    //component.find(component.get('v.auraId')).set("v.options", opts);
     //    component.find('auraId').set("v.options", opts);
    }
})