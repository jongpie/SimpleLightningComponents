({
    fetchFieldSetMetadata : function(component, event) {
        var sobjectName = component.get('v.sobjectName');
        var fieldSetName = component.get('v.fieldSetName');

        if(!sobjectName || !fieldSetName) return;

        var params = event.getParam('arguments');

        var action = component.get('c.getFieldSetMetadataByName');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldSetName': component.get('v.fieldSetName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var fieldSetMetadata = response.getReturnValue();
                component.set('v.fieldSetMetadata', fieldSetMetadata);

                if(params) params.callback(null, fieldSetMetadata);
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