({
    doInit :  function(component, event, helper) {
        var record = component.get('v.record');
        var fieldName = component.get('v.fieldName');
        if(record.hasOwnProperty(fieldName)) {
            component.set('v.selectedParentRecordId', record[fieldName]);
        }
    },
    parseFieldMetadata :  function(component, event, helper) {
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
        component.set('v.showSObjectSelector', false);
    },
    loadParentSObjectMetadata : function(component, event, helper) {
        component.set('v.searchResults', null);

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
    loadSelectedParentRecord :  function(component, event, helper) {
        var selectedParentRecordId = component.get('v.selectedParentRecordId');
        var selectedParentRecord   = component.get('v.selectedParentRecord');

        // If no record ID, then there's nothing to load
        if(selectedParentRecordId === null) return;

        // If we already have the parent record loaded, don't query again
        if(selectedParentRecord !== null && selectedParentRecordId === selectedParentRecord.Id) return;

        // Query for the parent record
        helper.fetchSelectedParentRecord(component, event, helper);
    },
    fetchSearchResults :  function(component, event, helper) {
        helper.fetchSearchResults(component, event, helper);
        component.set('v.showSearchResults', true);
    },
    hideSearchResults : function(component, event, helper) {
        component.set('v.showSearchResults', false);
    },
    parentRecordSelected : function(component, event, helper) {
        helper.parentRecordSelected(component, event, helper);
    },
    clearSelection : function(component, event, helper) {
        helper.clearSelection(component, event, helper);
    }
})