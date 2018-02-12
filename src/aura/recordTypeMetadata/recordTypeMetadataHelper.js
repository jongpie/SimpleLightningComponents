({
    fetchRecordTypeMetadata : function(component, event) {
        var recordTypeId      = component.get('v.recordTypeId');
        var sobjectApiName    = component.get('v.sobjectApiName');
        var recordTypeApiName = component.get('v.recordTypeApiName');

        if(!recordTypeId && !recordTypeApiName) return;

        var params = event.getParam('arguments');

        var action;
        // If we have the ID, get by ID
        if(recordTypeId) {
            action = component.get('c.getRecordTypeMetadataById');
            action.setParams({
                recordTypeId : recordTypeId
            });
        } else {
            // Otherwise, use the API name
            action = component.get('c.getRecordTypeMetadataByApiName');
            action.setParams({
                sobjectApiName    : sobjectApiName,
                recordTypeApiName : recordTypeApiName
            });
        }
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