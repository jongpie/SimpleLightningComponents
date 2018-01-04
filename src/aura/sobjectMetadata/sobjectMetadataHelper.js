({
    fetchSObjectMetadata : function(component, event) {
        var action = component.get('c.getSObjectMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var sobjectMetadata = response.getReturnValue();
                console.log(sobjectMetadata);
                component.set('v.sobjectMetadata', sobjectMetadata);
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