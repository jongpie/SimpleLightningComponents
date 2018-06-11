/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class ContextMetadata {

    @AuraEnabled global final Boolean IsApexRest         {get; private set;}
    @AuraEnabled global final Boolean IsBatch            {get; private set;}
    @AuraEnabled global final Boolean IsExecuting        {get; private set;}
    @AuraEnabled global final Boolean IsFuture           {get; private set;}
    @AuraEnabled global final Boolean IsLightning        {get; private set;}
    @AuraEnabled global final Boolean IsLightningConsole {get; private set;}
    @AuraEnabled global final Boolean IsQueueable        {get; private set;}
    @AuraEnabled global final Boolean IsSalesforce1      {get; private set;}
    @AuraEnabled global final Boolean IsScheduled        {get; private set;}
    @AuraEnabled global final Boolean IsVisualforce      {get; private set;}

    global ContextMetadata() {
        this.IsApexRest         = RestContext.request != null;
        this.IsBatch            = System.isBatch();
        this.IsExecuting        = Trigger.isExecuting;
        this.IsFuture           = System.isFuture();
        this.IsLightning        = UserInfo.getUiThemeDisplayed() == 'Theme4d';
        this.IsLightningConsole = UserInfo.getUiThemeDisplayed() == 'Theme4u';
        this.IsQueueable        = System.isQueueable();
        this.IsSalesforce1      = UserInfo.getUiThemeDisplayed() == 'Theme4t';
        this.IsScheduled        = System.isScheduled();
        this.IsVisualforce      = ApexPages.currentPage() != null;
    }

}