({
	doInit : function(component, event, helper) {
        var object       = component.get('v.object');
        var propertyName = component.get('v.propertyName');

        if(object.hasOwnProperty(propertyName)) {
            component.set('v.displayValue', object[propertyName]);
        }
	}
})