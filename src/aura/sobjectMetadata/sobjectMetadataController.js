({
    doInit : function(component, event, helper) {
        console.log('sobjectMetadata init');
        helper.fetchSObjectMetadata(component, event);
    },
    clearCachedMetadata : function(component, event, helper) {
        component.set('v.sobjectMetadata', null);
    }
    // fetch : function(component, event, helper) {
    //     console.log('sobjectMetadata load');
    //     var params = event.getParam("arguments");
    //     console.log(params);
    //     /*var action = component.get("c.getAccounts");
    //     action.setCallback(this, function(response) {
    //         if (response.getState() === "SUCCESS") {
    //             params.callback(null, response.getReturnValue());
    //         } else {
    //             params.callback(response.getError());
    //         }
    //     });
    //     $A.enqueueAction(action);*/





    //     var sobjectName = component.get('v.sobjectName');

    //     if(!sobjectName) return;

    //     var action = component.get('c.getSObjectMetadata');
    //     action.setParams({
    //         'sobjectName': sobjectName
    //     });
    //     action.setStorable();
    //     action.setCallback(this, function(response) {
    //         if(response.getState() === 'SUCCESS') {
    //             var sobjectMetadata = response.getReturnValue();
    //             console.log(sobjectMetadata);
    //             component.set('v.sobjectMetadata', sobjectMetadata);
    //             params.callback(null, response.getReturnValue());
    //         } else if(response.getState() === 'ERROR') {
    //             console.log('ERROR');
    //             for(var i=0; i < response.getError().length; i++) {
    //                console.log(response.getError()[i]);
    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);
    // }
})