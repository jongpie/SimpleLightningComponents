({
    doInit : function(component, event, helper) {
        console.log('controller.doInit');

        helper.fetchFieldNamesMetadata(component, event);
        helper.fetchFieldSetMetadata(component, event);
    },
    doneRendering : function(component, event, helper) {
        console.log('controller.doneRendering');

        component.set('v.isDoneRendering', true);
    },
    sortByField : function(component, event, helper) {
        var currentSortField = component.get('v.sortField');
        var fieldName = event.currentTarget.dataset.fieldname;
        component.set('v.sortField', fieldName);

        var sortIsAsc = component.get('v.sortIsAsc');
        if(fieldName == currentSortField) sortIsAsc = !sortIsAsc;
        component.set('v.sortIsAsc', sortIsAsc);
        var sortArrow = sortIsAsc ? '   ▲' : '   ▼'
        component.set('v.sortArrow', sortArrow);

        component.set('v.pageNumber', 1);
    },
    previousPage : function(component, event, helper) {
        var currentPageNumber = component.get('v.pageNumber');
        var previousPageNumber = currentPageNumber > 1 ? currentPageNumber - 1 : 1;
        component.set('v.pageNumber', previousPageNumber);
    },
    nextPage : function(component, event, helper) {
        var currentPageNumber = component.get('v.pageNumber');
        var totalPages = component.get('v.totalPages')
        var nextPageNumber = currentPageNumber < totalPages ? currentPageNumber + 1 : totalPages;
        component.set('v.pageNumber', nextPageNumber);
    },
})