({
    fetchSObjectMetadata : function(component, event) {
        var action = component.get("c.getSObjectMetadata");
        action.setParams({
            "sobjectName": component.get("v.sobjectName")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.sobjectMetadata', response.getReturnValue());

                component.set('v.label', response.getReturnValue().sobjectLabel);
                component.set('v.labelPlural', response.getReturnValue().sobjectLabelPlural);
            }
        });
        $A.enqueueAction(action);
    }
})