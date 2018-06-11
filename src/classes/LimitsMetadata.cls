/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class LimitsMetadata {

    @AuraEnabled global final LimitUsageMetadata AggregateQueries     {get; private set;}
    @AuraEnabled global final LimitUsageMetadata AsyncCalls           {get; private set;}
    @AuraEnabled global final LimitUsageMetadata Callouts             {get; private set;}
    @AuraEnabled global final LimitUsageMetadata CpuTime              {get; private set;}
    @AuraEnabled global final LimitUsageMetadata DmlRows              {get; private set;}
    @AuraEnabled global final LimitUsageMetadata DmlStatements        {get; private set;}
    @AuraEnabled global final LimitUsageMetadata EmailInvocations     {get; private set;}
    @AuraEnabled global final LimitUsageMetadata FutureCalls          {get; private set;}
    @AuraEnabled global final LimitUsageMetadata HeapSize             {get; private set;}
    @AuraEnabled global final LimitUsageMetadata MobilePushApexCalls  {get; private set;}
    @AuraEnabled global final LimitUsageMetadata QueueableJobs        {get; private set;}
    @AuraEnabled global final LimitUsageMetadata SoqlQueryLocatorRows {get; private set;}
    @AuraEnabled global final LimitUsageMetadata SoqlQueryRows        {get; private set;}
    @AuraEnabled global final LimitUsageMetadata SoqlQueries          {get; private set;}
    @AuraEnabled global final LimitUsageMetadata SoslSearches         {get; private set;}

    global LimitsMetadata() {
        this.AggregateQueries     = new LimitUsageMetadata(Limits.getAggregateQueries(), Limits.getLimitAggregateQueries());
        this.AsyncCalls           = new LimitUsageMetadata(Limits.getAsyncCalls(), Limits.getLimitAsyncCalls());
        this.Callouts             = new LimitUsageMetadata(Limits.getCallouts(), Limits.getLimitCallouts());
        this.CpuTime              = new LimitUsageMetadata(Limits.getCPUTime(), Limits.getLimitCPUTime());
        this.DmlRows              = new LimitUsageMetadata(Limits.getDmlRows(), Limits.getLimitDmlRows());
        this.DmlStatements        = new LimitUsageMetadata(Limits.getDmlStatements(), Limits.getLimitDmlStatements());
        this.EmailInvocations     = new LimitUsageMetadata(Limits.getEmailInvocations(), Limits.getLimitEmailInvocations());
        this.FutureCalls          = new LimitUsageMetadata(Limits.getFutureCalls(), Limits.getLimitFutureCalls());
        this.HeapSize             = new LimitUsageMetadata(Limits.getHeapSize(), Limits.getLimitHeapSize());
        this.MobilePushApexCalls  = new LimitUsageMetadata(Limits.getMobilePushApexCalls(), Limits.getLimitMobilePushApexCalls());
        this.QueueableJobs        = new LimitUsageMetadata(Limits.getQueueableJobs(), Limits.getLimitQueueableJobs());
        this.SoqlQueries          = new LimitUsageMetadata(Limits.getQueries(), Limits.getLimitQueries());
        this.SoqlQueryLocatorRows = new LimitUsageMetadata(Limits.getQueryLocatorRows(), Limits.getLimitQueryLocatorRows());
        this.SoqlQueryRows        = new LimitUsageMetadata(Limits.getQueryRows(), Limits.getLimitQueryRows());
        this.SoslSearches         = new LimitUsageMetadata(Limits.getSoslQueries(), Limits.getLimitSoslQueries());
    }

    global class LimitUsageMetadata {

        @AuraEnabled global final Integer Max {get; private set;}
        @AuraEnabled global final Integer Used {get; private set;}

        global LimitUsageMetadata(Integer used, Integer max){
            this.Max  = max;
            this.Used = used;
        }

    }

}