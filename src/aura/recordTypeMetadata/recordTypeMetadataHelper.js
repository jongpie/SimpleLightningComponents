({
    fetchRecordTypeMetadata : function(component, event) {
        var recordTypeId = component.get('v.recordTypeId');

        if(!recordTypeId) return;

        var params = event.getParam('arguments');

        var action = component.get('c.getRecordTypeMetadataById');
        action.setParams({
            recordTypeId : component.get('v.recordTypeId')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var recordTypeMetadata = response.getReturnValue();
                console.log('recordTypeMetadata');
                console.log(recordTypeMetadata);
                component.set('v.recordTypeMetadata', recordTypeMetadata);

                if(params) params.callback(null, recordTypeMetadata);
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