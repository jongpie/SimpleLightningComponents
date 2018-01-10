({
    fetchSelectedParentRecord : function(component, event, helper) {
        var parentSObjectMetadata = component.get('v.parentSObjectMetadata');
        var action = component.get('c.getRecord');
        action.setParams({
            recordId : component.get('v.selectedParentRecordId')
        });
        action.setStorable();
        action.setCallback(this, function(response) {
            component.set('v.selectedParentRecord', response.getReturnValue());
            component.set('v.parentSObjectName', response.getReturnValue().sobjectName);
        });
        $A.enqueueAction(action);
    },
    fetchSearchResults : function(component, event, helper) {
        var searchText = event && event.target ? event.target.value : null;

        var escapeKeyCode = 27;
        if(event.keyCode == escapeKeyCode) {
            helper.clearSelection(component, event, helper);
        } else {
            var parentSObjectMetadata = component.get('v.parentSObjectMetadata');
            var action = component.get('c.search');
            action.setParams({
                parentSObjectName    : parentSObjectMetadata.name,
                searchFieldName      : parentSObjectMetadata.nameField,
                searchText           : searchText,
                displayTextFieldName : parentSObjectMetadata.nameField,
                limitCount           : component.get('v.limitCount')
            });
            action.setStorable();
            action.setCallback(this, function(response) {
                this.handleResponse(response, component, helper);
            });
            $A.enqueueAction(action);
        }
    },
    itemSelected : function(component, event, helper) {
        var selectedParentRecordIndex = helper.getIndexFrmParent(event.target, helper, 'data-selectedIndex');
        if(selectedParentRecordIndex) {
            var searchResults = component.get('v.searchResults');
            var record = component.get('v.record');
            var fieldName = component.get('v.fieldName');
            var selectedParentRecord = searchResults[selectedParentRecordIndex];

            if(selectedParentRecord.record) {
                record[fieldName] = selectedParentRecord.record.Id;
                component.set('v.selectedParentRecord', selectedParentRecord);
            }
            component.set('v.searchResults', null);
        }
    },
    clearSelection: function(component, event, helper) {
        component.set('v.selectedParentRecord', null);
        component.set('v.searchResults', null);
    },
    handleResponse : function (response,component,helper) {
        if(response.getState() === 'SUCCESS') {
            var searchResults = response.getReturnValue();
            if(searchResults.length === 0) {
                component.set('v.searchResults', null);
            } else {
                component.set('v.searchResults', searchResults);
            }
        } else if(response.getState() === 'ERROR') {
            var errors = response.getError();
            if(errors && errors[0] && errors[0].message) {
                alert(errors[0].message);
            }
        }
    },
    getIndexFrmParent : function(target, helper, attributeToFind) {
        // User can click on any child element, so traverse till intended parent found
        var selectedParentRecordIndex = target.getAttribute(attributeToFind);
        while(!selectedParentRecordIndex) {
            target = target.parentNode;
            selectedParentRecordIndex = helper.getIndexFrmParent(target, helper, attributeToFind);
        }
        return selectedParentRecordIndex;
    }
})