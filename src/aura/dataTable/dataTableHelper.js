({
    fetchFieldSetMetadata : function(component, event) {
        var fields = component.get('v.fields');
        var fieldSet = component.get('v.fieldSetName');

        if(fields.length > 0 || fieldSet == null) return;

        var action = component.get('c.getFieldSetMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldSetName': component.get('v.fieldSetName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                var fieldSetMetadata = response.getReturnValue();
                component.set('v.fields', response.getReturnValue())
            } else {
                console.log('ERROR');
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})