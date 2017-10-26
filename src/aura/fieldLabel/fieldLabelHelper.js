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
                console.log('ERROR');
                for(var i=0; i < response.getError().length; i++) {
                   console.log(response.getError()[i]);
                }
            }
        });
        $A.enqueueAction(action);
    }
})