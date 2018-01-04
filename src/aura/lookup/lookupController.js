({
    fetchSearchResults :  function(component, event, helper) {
        console.log('fetchSearchResults');
        component.set('v.showSearchResults', true);
        helper.fetchSearchResults(component, event, helper);
    },
    hideSearchResults : function(component, event, helper) {
        console.log('hideSearchResults');
        component.set('v.showSearchResults', false);
    },
    itemSelected : function(component, event, helper) {
        console.log('itemSelected');
        helper.itemSelected(component, event, helper);
    },
    clearSelection : function(component, event, helper) {
        console.log('clearSelection');
        helper.clearSelection(component, event, helper);
    }
})