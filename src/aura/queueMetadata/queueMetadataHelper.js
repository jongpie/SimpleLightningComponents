({
    fetchQueueMetadata : function(component, event) {
        var queueId      = component.get('v.queueId');
        var queueApiName = component.get('v.queueApiName');

        if(!queueId && !queueApiName) return;

        var params = event.getParam('arguments');
        var action;
        // If we have the ID, get by ID
        if(queueId) {
           action = component.get('c.getQueueMetadataById');
           action.setParams({
               queueId : queueId
           });
       } else {
           // Otherwise, use the API name
           action = component.get('c.getQueueMetadataByApiName');
           action.setParams({
               queueApiName : queueApiName
           });
       }
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var queueMetadata = response.getReturnValue();
                component.set('v.queueMetadata', queueMetadata);

                if(params) params.callback(null, queueMetadata);
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