({
    doInit : function(component, event, helper) {
        helper.getSecondaryRecords(component);
    },

    createJunctionRecords: function (component, event, helper) {
        //component.set('v.stepNumber', 2);
        helper.createJunctionRecords(component, event);
    },
    rowSelected : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');

        component.set('v.selectedSecondarySobjectRecords', selectedRows);
    },
    removeSelectedRecord : function(component, event, helper) {
        console.log('remove pill');
        console.log(event.getSource());
        var pillRecordId = event.getSource().get('v.name');
        console.log('clicked to remove: ' + pillRecordId);

        var selectedSecondarySobjectRecords = component.get('v.selectedSecondarySobjectRecords');
        var selectedRows = [];
        var selectedRowIds = [];
        for(var i = 0; i < selectedSecondarySobjectRecords.length; i++) {
            if(pillRecordId === selectedSecondarySobjectRecords[i].Id) {
                console.log('gonna remove pillRecordId=' + pillRecordId);
                selectedSecondarySobjectRecords.splice(i, 1);
                break;
            } else {
                selectedRows.push(selectedSecondarySobjectRecords[i]);
                selectedRowIds.push(selectedSecondarySobjectRecords[i].Id);
            }
        }
        component.set('v.selectedSecondarySobjectRecords', selectedRows);
        component.find('secondarySobjectRecords').set('v.selectedRows', selectedRowIds);
    },
    saveJunctionRecords: function (component, event, helper) {
        helper.saveJunctionRecords(component, event);
    },
    back: function (component, event, helper) {
        component.set('v.stepNumber', 1);
    },
    pageMovement: function (component, event, helper) {
        helper.pageMovement(component, event);
    },
    getSelectedRows : function(component, event, helper) {
        helper.insertOpportunityLineItems(component, event, helper);
    }
})