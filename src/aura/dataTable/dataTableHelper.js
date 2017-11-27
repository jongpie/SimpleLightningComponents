({
    fetchFieldNamesMetadata : function(component, event) {
        console.log('helper.fetchFieldNamesMetadata');

        var fieldNames = component.get('v.fieldNames');

        if(fieldNames == null || fieldNames.length == 0) return;
console.log('passed guard clause');
        var action = component.get('c.getFieldMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldNames': component.get('v.fieldNames')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                console.log('response.getReturnValue()')
                component.set('v.fields', response.getReturnValue())
            } else {
                console.log('ERROR');
                for(var i=0; i < response.getError().length; i++) {
                    console.log(response.getError()[0]);
                }
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    fetchFieldSetMetadata : function(component, event) {
        console.log('helper.fetchFieldSetMetadata');

        var fieldNames = component.get('v.fieldNames');
        var fieldSet = component.get('v.fieldSetName');
console.log(JSON.stringify(fieldSet));
console.log(fieldNames);
console.log(fieldNames.length);
console.log(fieldNames.length > 0);
console.log(fieldSet == null);
        if(fieldNames.length > 0 || fieldSet == null) return;
console.log('action!');
        var action = component.get('c.getFieldSetMetadata');
        action.setParams({
            'sobjectName': component.get('v.sobjectName'),
            'fieldSetName': fieldSet
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                var fieldSetMetadata = response.getReturnValue();
                console.log('fieldSetMetadata');
                console.table(fieldSetMetadata);
                component.set('v.fields', response.getReturnValue())
            } else {
                console.log('ERROR');
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})