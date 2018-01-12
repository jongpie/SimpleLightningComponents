({
    fetchSObjectMetadata : function(component, event) {
        var sobjectMetadata = component.get('v.sobjectMetadata');

        // If we already have the sobject metadata cached, use the cache
        if(sobjectMetadata) return;

        var sobjectName = component.get('v.sobjectName');
        var params = event.getParam('arguments');

        if(!sobjectName) return;

        var action = component.get('c.getSObjectMetadata');
        action.setParams({
            'sobjectName': sobjectName
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var sobjectMetadata = response.getReturnValue();
                component.set('v.sobjectMetadata', sobjectMetadata);

                if(params) params.callback(null, sobjectMetadata);
            } else if(response.getState() === 'ERROR') {
                console.log('ERROR');
                for(var i=0; i < response.getError().length; i++) {
                   console.log(response.getError()[i]);
                }
            }
        });
        $A.enqueueAction(action);
    }
})