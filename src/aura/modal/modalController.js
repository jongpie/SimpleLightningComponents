({
    openModal : function(component, event, helper) {
        component.set('v.showModal', true);
        document.body.style.overflow = 'hidden';
        console.log('v.showModal=' + component.get('v.showModal'));
    },
    closeModal : function(component, event, helper) {
        component.set('v.showModal', false);
        document.body.style.overflow = 'auto';
    },
})