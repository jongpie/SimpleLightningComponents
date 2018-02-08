({
    fetchCurrentUser : function(component, event) {
        var params = event.getParam('arguments');

        var action = component.get('c.getCurrentUser');
        action.setParams({
            'additionalFieldApiNames': component.get('v.additionalFieldApiNames')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var currentUser = response.getReturnValue();
                component.set('v.currentUser', currentUser);

                if(params) params.callback(null, currentUser);
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