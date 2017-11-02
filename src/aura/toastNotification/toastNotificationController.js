({
    doInit : function(component, event, helper) {
        console.log('doInit');
    },
    closeNotification : function(component, event, helper) {
        component.destroy();
    },
    handleNotification : function(component, event, helper) {
        component.set('v.errorMessage', event.getParam('errorMessage'));
        component.set('v.errorDetails', event.getParam('errorDetails'));
    }
})