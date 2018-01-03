({
    fetchSearchResults : function(component, event, helper) {
        var target = event.target;
        var searchText = target.value;
        var last_SearchText = component.get('v.last_SearchText');
        //Escape button pressed
        if(event.keyCode == 27 || !searchText.trim()) {
            helper.clearSelection(component, event, helper);
        } else if(searchText.trim() != last_SearchText  && /\s+$/.test(searchText)) {
            //Save server call, if last text not changed
            //Search only when space character entered

            var sobjectName = component.get('v.sobjectName');
            var displayTextFieldName = component.get('v.displayTextFieldName');
            //var fieldName = component.get('v.fieldName');
            var searchFieldName = component.get('v.searchFieldName');
            var limit = component.get('v.limit');

            var action = component.get('c.search');
            action.setStorable();

            action.setParams({
                sobjectName          : sobjectName,
                searchFieldName      : searchFieldName,
                searchText           : searchText,
                displayTextFieldName : displayTextFieldName,
                limitCount           : limit
            });

            action.setCallback(this,function(a) {
                this.handleResponse(a,component,helper);
            });

            component.set('v.last_SearchText',searchText.trim());
            console.log('Server call made');
            $A.enqueueAction(action);
        } else if(searchText && last_SearchText && searchText.trim() == last_SearchText.trim()) {
            component.set('v.searchResults', component.get('v.last_ServerResult'));
            console.log('Server call saved');
        }
    },
    itemSelected : function(component, event, helper) {
        var target = event.target;
        var selectedRecordIndex = helper.getIndexFrmParent(target, helper, 'data-selectedIndex');
        if(selectedRecordIndex) {
            var serverResult = component.get('v.searchResults');
            var selectedRecord = serverResult[selectedRecordIndex];
            console.log('selectedRecord');
            console.log(selectedRecord);
            if(selectedRecord.recordId) {
               component.set('v.selectedRecord', selectedRecord);
               component.set('v.last_ServerResult', serverResult);
            }
            component.set('v.searchResults', null);
        }
    },
    clearSelection: function(component, event, helper) {
        component.set('v.selectedRecord', null);
        component.set('v.searchResults', null);
    },
    handleResponse : function (res,component,helper) {
        if(res.getState() === 'SUCCESS') {
            var retObj = JSON.parse(res.getReturnValue());
            if(retObj.length <= 0) {
                var noResult = JSON.parse('[{"text":"No Results Found"}]');
                component.set('v.searchResults', noResult);
                component.set('v.last_ServerResult', noResult);
            } else {
                component.set('v.searchResults', retObj);
                component.set('v.last_ServerResult', retObj);
            }
        }else if(res.getState() === 'ERROR') {
            var errors = res.getError();
            if(errors && errors[0] && errors[0].message) {
                alert(errors[0].message);
            }
        }
    },
    getIndexFrmParent : function(target, helper, attributeToFind) {
        //User can click on any child element, so traverse till intended parent found
        var selectedRecordIndex = target.getAttribute(attributeToFind);
        while(!selectedRecordIndex) {
            target = target.parentNode;
            selectedRecordIndex = helper.getIndexFrmParent(target, helper, attributeToFind);
        }
        return selectedRecordIndex;
    }
})