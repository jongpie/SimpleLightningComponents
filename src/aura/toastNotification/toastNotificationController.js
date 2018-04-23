({
    closeNotification : function(component, event, helper) {
        component.set('v.render', false);
        component.set('v.type', null);
        component.set('v.title', null);
        component.set('v.details', null);
    },
    handleNotificationEvent : function(component, event, helper) {
        var hasType = event.getParam('type') !== null;
        component.set('v.render', hasType);
        component.set('v.type', event.getParam('type'));
        component.set('v.title', event.getParam('title'));
        component.set('v.details', event.getParam('details'));
    }
})