({
    doInit :  function(component, event, helper) {
        var fieldMetadata = component.get('v.fieldMetadata');

        if(!fieldMetadata) return;

        var defaultRelationshipReference;
        for(var i = 0; i < fieldMetadata.relationshipReferences.length; i++) {
            var relationshipReference = fieldMetadata.relationshipReferences[i];
            if(relationshipReference.isAccessible === true) {
                defaultRelationshipReference = relationshipReference;
                break;
            }
        }
        component.set('v.parentSObjectName', defaultRelationshipReference.name);
    },
    toggleParentSObjectSelector : function(component, event, helper) {
        component.set('v.showSObjectSelector', !component.get('v.showSObjectSelector'));
        component.set('v.showSearchResults', !component.get('v.showSearchResults'));
    },
    selectParentSObject : function(component, event, helper) {
        var parentSObjectName = event.currentTarget.dataset.sobjectname;
        component.set('v.parentSObjectName', parentSObjectName);
    },
    loadParentSObjectMetadata : function(component, event, helper) {
        component.set('v.showSearchResults', null);
        component.set('v.showSObjectSelector', false);

        var fieldMetadata = component.get('v.fieldMetadata');
        var parentSObjectName = component.get('v.parentSObjectName');

        var selectedSObjectMetadata;
        for(var i = 0; i < fieldMetadata.relationshipReferences.length; i++) {
            var relationshipReference = fieldMetadata.relationshipReferences[i];

            if(relationshipReference.name !== parentSObjectName) continue;

            selectedSObjectMetadata = fieldMetadata.relationshipReferences[i];
            break;
        }
        component.set('v.parentSObjectMetadata', selectedSObjectMetadata);
    },
    fetchSearchResults :  function(component, event, helper) {
        helper.fetchSearchResults(component, event, helper);
        component.set('v.showSearchResults', true);
    },
    hideSearchResults : function(component, event, helper) {
        component.set('v.showSearchResults', false);
    },
    itemSelected : function(component, event, helper) {
        helper.itemSelected(component, event, helper);
    },
    clearSelection : function(component, event, helper) {
        helper.clearSelection(component, event, helper);
    }
})