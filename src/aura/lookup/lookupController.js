({
    doInit :  function(component, event, helper) {
        console.log('lookup doInit');
        var fieldMetadata = component.get('v.fieldMetadata');

        if(!fieldMetadata) return;

        var parentSObjectName = fieldMetadata.relationshipReferences[0];
        //if(!component.get('v.parentSObjectMetadata')) return;
        /*$A.createComponent(
            "sobjectMetadata",
            {
                "aura:id": "parentSObjectMetadataCmp",
                "sobjectName": parentSObjectName
            },
            function(newSObjectMetadataCmp, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newSObjectMetadataCmp);
                    component.set("v.body", body);
                    console.log('added sobjectMetadataCmp');
                    console.log(component.get('v.body'));
                    console.log(component.get('v.body').find('parentSObjectMetadataCmp'));
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );*/

var parentSObjectMetadataComponent = component.find('parentSObjectMetadataCmp');

if(!parentSObjectMetadataComponent || !parentSObjectMetadataComponent.get('v.sobjectMetadata')) return;

var parentSObjectMetadata = parentSObjectMetadataComponent.get('v.sobjectMetadata');

console.log('parentSObjectMetadata');
console.log(parentSObjectMetadata);
console.log('done parentSObjectMetadata');
component.set('v.parentSObjectMetadata', parentSObjectMetadata);
console.log('parentSObjectMetadata');
console.log(parentSObjectMetadata);
component.find('parentSObjectMetadataCmp').set('v.parentSObjectName', parentSObjectName);
/*component.set('v.parentSObjectName', parentSObjectMetadata.name);
component.set('v.displayTextFieldName', parentSObjectMetadata.nameField);
component.set('v.searchFieldName', parentSObjectMetadata.nameField);*/


    },
    fetchSearchResults :  function(component, event, helper) {
        console.log('fetchSearchResults');
        var fieldMetadata = component.get('v.fieldMetadata');

        if(!fieldMetadata) return;

        var parentSObjectName = fieldMetadata.relationshipReferences[0];

        var parentSObjectMetadata = component.get('v.parentSObjectMetadata');
        if(!parentSObjectMetadata) {
            var parentSObjectMetadataComponent = component.find('parentSObjectMetadataCmp');

            if(!parentSObjectMetadataComponent || !parentSObjectMetadataComponent.get('v.sobjectMetadata')) return;

            var parentSObjectMetadata = parentSObjectMetadataComponent.get('v.sobjectMetadata');

            console.log('parentSObjectMetadata');
            console.log(parentSObjectMetadata);
            console.log('done parentSObjectMetadata');
            component.set('v.parentSObjectMetadata', parentSObjectMetadata);
            console.log('parentSObjectMetadata');
            console.log(parentSObjectMetadata);
            component.find('parentSObjectMetadataCmp').set('v.sobjectName', parentSObjectName);
        }


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