({
    fetchFieldSetMetadata : function(component, event) {
        var sobjectApiName  = component.get('v.sobjectApiName');
        var fieldSetApiName = component.get('v.fieldSetApiName');

        if(!sobjectApiName || !fieldSetApiName) return;

        var params = event.getParam('arguments');

        var action = component.get('c.getFieldSetMetadataByApiName');
        action.setParams({
            sobjectApiName  : component.get('v.sobjectApiName'),
            fieldSetApiName : component.get('v.fieldSetApiName')
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