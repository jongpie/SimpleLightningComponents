({
    fetchFieldMetadata : function(component, event) {
        var sobjectApiName = component.get('v.sobjectApiName');
        var fieldApiName   = component.get('v.fieldApiName');

        if(!sobjectApiName || !fieldApiName) return;

        var params = event.getParam('arguments');

        var action = component.get('c.getFieldMetadataByApiName');
        action.setParams({
            sobjectApiName : sobjectApiName,
            fieldApiName   : fieldApiName
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var fieldMetadata = response.getReturnValue();
                component.set('v.fieldMetadata', fieldMetadata);

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