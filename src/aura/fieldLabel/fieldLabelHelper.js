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
                component.set('v.fieldMetadata', response.getReturnValue());
                component.set('v.label', response.getReturnValue().label);
            } else if(response.getState() == 'ERROR') {
                console.log('Error');
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})