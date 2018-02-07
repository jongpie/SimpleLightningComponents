({
    fetchEnvironmentMetadata : function(component, event) {
        var params = event.getParam('arguments');

        var action = component.get('c.getEnvironmentMetadata');
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var environmentMetadata = response.getReturnValue();
                component.set('v.environmentMetadata', environmentMetadata);

                if(params) params.callback(null, environmentMetadata);
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