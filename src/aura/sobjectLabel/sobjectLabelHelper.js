({
    fetchSObjectMetadata : function(component, event) {
        var action = component.get('c.getSObjectMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                var sobjectMetadata = response.getReturnValue();
                component.set('v.sobjectMetadata', sobjectMetadata);
                component.set('v.label', sobjectMetadata.label);
                component.set('v.labelPlural', sobjectMetadata.labelPlural);
            } else if(response.getState() == 'ERROR') {
                console.log('Error');
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})