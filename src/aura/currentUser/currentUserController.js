({
    doInit : function(component, event, helper) {
        console.log('currentUser.doInit');
        helper.fetchCurrentUser(component, event);
    }
})