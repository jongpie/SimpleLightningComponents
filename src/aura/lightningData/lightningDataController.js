({
    doInit : function(component, event, helper) {

    },
    query : function(component, event, helper) {
        //var eventParams       = event.getParam('arguments');
        var action       = component.get('c.queryRecords');
        var cacheResults = component.get('v.cacheResults');

        if(cacheResults) action.setStorable();

        var queryPparameters = helper.getQueryParameters(component, event);
        console.log('queryPparameters');
        console.log(queryPparameters);
        action.setParams({
            parameterString : JSON.stringify(queryPparameters)
        });
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                var queryResults = response.getReturnValue();
                console.log('queryResults');
                console.log(queryResults);

                component.set('v.queryResults', queryResults)
                //eventParams.callback(null, queryResults );
            } else {
                console.log('Error');
                console.log(response.getError());
                //eventParams.callback(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
})