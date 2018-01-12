({
    fetchFieldMetadata : function(component, event) {
        var sobjectName = component.get('v.sobjectName');
        var fieldName = component.get('v.fieldName');

        if(!sobjectName || !fieldName) return;

        var params = event.getParam('arguments');

        var action = component.get('c.getFieldMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldName': component.get('v.fieldName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var fieldMetadata = response.getReturnValue();
                component.set('v.fieldMetadata', fieldMetadata);
                component.set('v.label', fieldMetadata.label);

                if(params) params.callback(null, fieldMetadata);
            } else if(response.getState() === 'ERROR') {
                this.processCallbackErrors(response);
            }
        });
        $A.enqueueAction(action);
    },
    processCallbackErrors : function(response) {
        console.log('ERROR');
        for(var i=0; i < response.getError().length; i++) {
           console.log(response.getError()[i]);
        }
    }
})