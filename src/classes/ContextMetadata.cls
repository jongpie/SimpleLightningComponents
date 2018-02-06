/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class ContextMetadata {

    @AuraEnabled global final Boolean isApexRest         {get; private set;}
    @AuraEnabled global final Boolean isBatch            {get; private set;}
    @AuraEnabled global final Boolean isExecuting        {get; private set;}
    @AuraEnabled global final Boolean isFuture           {get; private set;}
    @AuraEnabled global final Boolean isLightning        {get; private set;}
    @AuraEnabled global final Boolean isLightningConsole {get; private set;}
    @AuraEnabled global final Boolean isQueueable        {get; private set;}
    @AuraEnabled global final Boolean isSalesforce1      {get; private set;}
    @AuraEnabled global final Boolean isScheduled        {get; private set;}
    @AuraEnabled global final Boolean isVisualforce      {get; private set;}

    global ContextMetadata() {
        this.isApexRest         = RestContext.request != null;
        this.isBatch            = System.isBatch();
        this.isExecuting        = Trigger.isExecuting;
        this.isFuture           = System.isFuture();
        this.isLightning        = UserInfo.getUiThemeDisplayed() == 'Theme4d';
        this.isLightningConsole = UserInfo.getUiThemeDisplayed() == 'Theme4u';
        this.isQueueable        = System.isQueueable();
        this.isSalesforce1      = UserInfo.getUiThemeDisplayed() == 'Theme4t';
        this.isScheduled        = System.isScheduled();
        this.isVisualforce      = ApexPages.currentPage() != null;
    }

}