({
    fetchListViewMetadata : function(component, event) {
        var sobjectApiName  = component.get('v.sobjectApiName');
        var listViewApiName = component.get('v.listViewApiName');

        if(!sobjectApiName || !listViewApiName) return;

        var params = event.getParam('arguments');

        var action = component.get('c.getListViewMetadataByName');
        action.setParams({
            sobjectApiName  : sobjectApiName,
            listViewApiName : listViewApiName
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var listViewMetadata = response.getReturnValue();
                component.set('v.listViewMetadata', listViewMetadata);

                if(params) params.callback(null, listViewMetadata);
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