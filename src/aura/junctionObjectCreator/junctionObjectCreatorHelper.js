({
    getPrimaryRecordData : function (component) {
        action.setParam("recordId", component.get("v.recordId"));

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var opportunity = response.getReturnValue();
                component.set("v.opportunity", opportunity);
            }
            else if (state === "ERROR") {
                alert("System error, please contact you administrator. Error data: " +  response.getError());
            }else{
                alert('Something went wrong, please contact your administrator.');
            }
        });
        $A.enqueueAction(action);
    },


    getSecondaryRecords : function (component) {
        var action = component.get('c.getSecondarySobjectRecords');
        action.setParams({
           sobjectApiName                    : component.get('v.secondarySobject'),
           fieldSetApiName                   : component.get('v.secondarySobjectFieldSet'),
           queryFilter                       : component.get('v.secondarySobjectQueryFilter'),
           //orderBy                           : component.get('v.secondarySobjectFieldSet'),
           excludeIfExistsInJunctionObject   : true//component.get('v.secondarySobjectFieldSet')
        });

        action.setCallback(this, function(response) {
           var state = response.getState();
           if(state === 'SUCCESS') {
            console.log('secondary objects=');
            console.log(response.getReturnValue());
                component.set('v.secondarySobjectRecordResults', response.getReturnValue());
           } else {
               alert('Something went wrong, please contact your administrator. ' + response.getError());
               console.log(response.getError());
           }
        });
        $A.enqueueAction(action);
     },

     createJunctionRecords : function (component) {
        var selectedRows = component.find('secondarySobjectRecords').getSelectedRows();
        console.log('selectedRows');
        console.log(selectedRows);
        var secondaryRecordIds = [];
        for(var i =0; i < selectedRows.length; i++) {
            var rowId = selectedRows[i].Id;
            console.log('rowId=' + rowId);
            secondaryRecordIds.push(rowId);
        }

        var action = component.get('c.createJunctionSobjectRecords');
        action.setParams({
           junctionSobjectApiName         : component.get('v.junctionSobject'),
           junctionSobjectFieldSetApiName : component.get('v.junctionSobjectFieldSet'),
           primarySobjectFieldApiName     : component.get('v.relationshipFieldToPrimarySobject'),
           secondarySobjectFieldApiName   : component.get('v.relationshipFieldToSecondarySobject'),
           primaryRecordId                : component.get('v.recordId'),
           secondaryRecordIds             : secondaryRecordIds
        });

        action.setCallback(this, function(response) {
           var state = response.getState();
           if(state === 'SUCCESS') {
                console.log('junctionSobjectRecordResults');
                console.log(response.getReturnValue());
                component.set('v.junctionSobjectRecordResults', response.getReturnValue());
                component.set('v.stepNumber', 2);
           } else {
               alert('Something went wrong, please contact your administrator. ' + response.getError());
           }
        });
        $A.enqueueAction(action);
    },
    saveJunctionRecords : function (component) {
         var action = component.get('c.saveJunctionSobjectRecords');
         action.setParams({
            records : component.get('v.junctionSobjectRecords')
         });

         action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                 component.set('v.secondarySobjectRecords', response.getReturnValue());
            } else {
                alert('Something went wrong, please contact your administrator. ' + response.getError());
            }
         });
         $A.enqueueAction(action);
     },

    pageMovement : function(component, event){

        var pageMovement    = event.getSource().get("v.value");
        var currentPage     = component.get("v.currentPage");
        var selectedRows    = component.find("recordEntries").getSelectedRows();
        var pageName        = "page" + currentPage;

        component.get("v.selectedRecords")[pageName] = selectedRows;

        if(pageMovement == 'NextPage'){
            currentPage         = currentPage + 1;
        }else{
            currentPage         = currentPage - 1;
        }

        component.set("v.currentPage",currentPage);

        console.log("All selected records: "+JSON.stringify(component.get("v.selectedRecords")));

        var sObjectList     = component.get("v.recordsData");
        var endPage         = component.get("v.endPage");
        var startPage       = component.get("v.startPage");
        var recordsPerPage  = component.get("v.recordsPerPage");
        var Paginationlist  = [];
        var counter         = 0;

        if(pageMovement == 'NextPage'){
            for(var i = endPage + 1; i < endPage + recordsPerPage + 1; i++){
                if(sObjectList.length > i){
                    Paginationlist.push(sObjectList[i]);
                }
                counter ++;
            }

            startPage   = startPage + counter;
            endPage     = endPage   + counter;

        }else{
            for(var i = startPage - recordsPerPage; i < startPage; i++){
                if(i > -1){
                    Paginationlist.push(sObjectList[i]);
                    counter ++;
                }else{
                    startPage ++;
                }

            }

            startPage   = startPage - counter;
            endPage     = endPage   - counter;
        }

        component.set("v.startPage",startPage);
        component.set("v.endPage",endPage);
        component.set('v.PaginationList', Paginationlist);

        pageName            = "page" + currentPage;
        var selectedRows    = component.get("v.selectedRecords")[pageName];

        if (typeof selectedRows != 'undefined' && selectedRows) {
            var selectedRowsIds = [];
            for(var i = 0; i< selectedRows.length; i++){
                selectedRowsIds.push(selectedRows[i].Id);
            }
            var dataTable = component.find("recordEntries");
            dataTable.set("v.selectedRows", selectedRowsIds);
        }
    },



})