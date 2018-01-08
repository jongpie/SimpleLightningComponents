({
    doInit :  function(component, event, helper) {
        console.log('lookup doInit');
        var fieldMetadata = component.get('v.fieldMetadata');

        if(!fieldMetadata) return;

        var defaultParentSObjectName = fieldMetadata.relationshipReferences[0].name;

        var sobjectMetadataService = component.find('sobjectMetadataService');
        sobjectMetadataService.set('v.sobjectName', defaultParentSObjectName);
        sobjectMetadataService.fetch(function(error, data) {
            component.set('v.parentSObjectMetadata', data);
        });
    },
    fetchSearchResults :  function(component, event, helper) {
        console.log('fetchSearchResults');
        helper.fetchSearchResults(component, event, helper);
        component.set('v.showSearchResults', true);
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