({
    getQueryParameters : function(component, event, helper) {
        return {
            sobjectType : component.get('v.sobjectType'),
            fields      : component.get('v.fields'),
            filters     : component.get('v.filters'),
            orderBy     : component.get('v.orderBy'),
            limitCount  : component.get('v.limitCount'),
            enforceFLS  : component.get('v.enforceFLS')
        };
    },
})