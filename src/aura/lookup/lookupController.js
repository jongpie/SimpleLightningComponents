({
    doInit :  function(component, event, helper) {
        var record = component.get('v.record');
        var fieldApiName = component.get('v.fieldApiName');
        if(record.hasOwnProperty(fieldApiName)) {
            component.set('v.selectedParentRecordId', record[fieldApiName]);
        }
    },
    parseFieldMetadata :  function(component, event, helper) {
        var fieldMetadata = component.get('v.fieldMetadata');

        if(!fieldMetadata) return;

        var defaultRelationshipReference;
        for(var i = 0; i < fieldMetadata.RelationshipReferences.length; i++) {
            var relationshipReference = fieldMetadata.RelationshipReferences[i];

            if(relationshipReference.IsAccessible === true) {
                defaultRelationshipReference = relationshipReference;
                break;
            }
        }
        component.set('v.parentSobjectApiName', defaultRelationshipReference.ApiName);
    },
    toggleParentSobjectSelector : function(component, event, helper) {
        component.set('v.showSobjectSelector', !component.get('v.showSobjectSelector'));
        component.set('v.showSearchResults', !component.get('v.showSearchResults'));
    },
    selectParentSobject : function(component, event, helper) {
        var parentSobjectApiName = event.currentTarget.dataset.sobjectapiname;
        component.set('v.parentSobjectApiName', parentSobjectApiName);
        component.set('v.showSobjectSelector', false);
    },
    loadParentSobjectMetadata : function(component, event, helper) {
        component.set('v.searchResults', null);

        var fieldMetadata = component.get('v.fieldMetadata');
        var parentSobjectApiName = component.get('v.parentSobjectApiName');

        var selectedSobjectMetadata;
        for(var i = 0; i < fieldMetadata.RelationshipReferences.length; i++) {
            var relationshipReference = fieldMetadata.RelationshipReferences[i];

            if(relationshipReference.ApiName !== parentSobjectApiName) continue;

            selectedSobjectMetadata = fieldMetadata.RelationshipReferences[i];
            break;
        }
        component.set('v.parentSobjectMetadata', selectedSobjectMetadata);
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