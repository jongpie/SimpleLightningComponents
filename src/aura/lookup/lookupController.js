({
    doInit :  function(component, event, helper) {
        console.log('lookup doInit');
        var fieldMetadata = component.get('v.fieldMetadata');

        if(!fieldMetadata) return;

        component.set('v.parentSObjectName', fieldMetadata.relationshipReferences[0].name);
    },
    toggleParentSObjectSelector : function(component, event, helper) {
        console.log('lookup toggleSObjectSelector');
        component.set('v.showSObjectSelector', !component.get('v.showSObjectSelector'));
        component.set('v.showSearchResults', !component.get('v.showSearchResults'));
    },
    selectParentSObject : function(component, event, helper) {
        console.log('lookup selectParentSObject');
        var parentSObjectName = event.currentTarget.dataset.sobjectname;
        console.log('parentSObjectName=' + parentSObjectName);
        component.set('v.parentSObjectMetadata', null);
        component.set('v.parentSObjectName', parentSObjectName);
        component.set('v.showSObjectSelector', false);
    },
    fetchParentSObjectMetadata :  function(component, event, helper) {
        var parentSObjectName = component.get('v.parentSObjectName');

        var sobjectMetadataService = component.find('sobjectMetadataService');
        sobjectMetadataService.set('v.sobjectName', parentSObjectName);
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