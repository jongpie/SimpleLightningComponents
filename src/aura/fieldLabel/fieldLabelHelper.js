({
    fetchFieldMetadata : function(component, event) {
        var action = component.get("c.getFieldMetadata");
        action.setParams({
            "sobjectName": component.get("v.sobjectName"),
            "fieldName": component.get("v.fieldName")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.fieldMetadata', response.getReturnValue());

                component.set('v.label', response.getReturnValue().fieldLabel);
            }
        });
        $A.enqueueAction(action);
    }
})