/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class LimitsMetadata {

    @AuraEnabled global final LimitUsageMetadata aggregateQueries    {get; private set;}
    @AuraEnabled global final LimitUsageMetadata asyncCalls          {get; private set;}
    @AuraEnabled global final LimitUsageMetadata callouts            {get; private set;}
    @AuraEnabled global final LimitUsageMetadata cpuTime             {get; private set;}
    @AuraEnabled global final LimitUsageMetadata dmlRows             {get; private set;}
    @AuraEnabled global final LimitUsageMetadata dmlStatements       {get; private set;}
    @AuraEnabled global final LimitUsageMetadata emailInvocations    {get; private set;}
    @AuraEnabled global final LimitUsageMetadata futureCalls         {get; private set;}
    @AuraEnabled global final LimitUsageMetadata heapSize            {get; private set;}
    @AuraEnabled global final LimitUsageMetadata mobilePushApexCalls {get; private set;}
    @AuraEnabled global final LimitUsageMetadata queries             {get; private set;}
    @AuraEnabled global final LimitUsageMetadata queryLocatorRows    {get; private set;}
    @AuraEnabled global final LimitUsageMetadata queryRows           {get; private set;}
    @AuraEnabled global final LimitUsageMetadata queueableJobs       {get; private set;}
    @AuraEnabled global final LimitUsageMetadata soslQueries         {get; private set;}

    global LimitsMetadata() {
        this.aggregateQueries    = new LimitUsageMetadata(Limits.getAggregateQueries(), Limits.getLimitAggregateQueries());
        this.asyncCalls          = new LimitUsageMetadata(Limits.getAsyncCalls(), Limits.getLimitAsyncCalls());
        this.callouts            = new LimitUsageMetadata(Limits.getCallouts(), Limits.getLimitCallouts());
        this.cpuTime             = new LimitUsageMetadata(Limits.getCPUTime(), Limits.getLimitCPUTime());
        this.dmlRows             = new LimitUsageMetadata(Limits.getDMLRows(), Limits.getLimitDMLRows());
        this.dmlStatements       = new LimitUsageMetadata(Limits.getDMLStatements(), Limits.getLimitDMLStatements());
        this.emailInvocations    = new LimitUsageMetadata(Limits.getEmailInvocations(), Limits.getLimitEmailInvocations());
        this.futureCalls         = new LimitUsageMetadata(Limits.getFutureCalls(), Limits.getLimitFutureCalls());
        this.heapSize            = new LimitUsageMetadata(Limits.getHeapSize(), Limits.getLimitHeapSize());
        this.mobilePushApexCalls = new LimitUsageMetadata(Limits.getMobilePushApexCalls(), Limits.getLimitMobilePushApexCalls());
        this.queries             = new LimitUsageMetadata(Limits.getQueries(), Limits.getLimitQueries());
        this.queryLocatorRows    = new LimitUsageMetadata(Limits.getQueryLocatorRows(), Limits.getLimitQueryLocatorRows());
        this.queryRows           = new LimitUsageMetadata(Limits.getQueryRows(), Limits.getLimitQueryRows());
        this.queueableJobs       = new LimitUsageMetadata(Limits.getQueueableJobs(), Limits.getLimitQueueableJobs());
        this.soslQueries         = new LimitUsageMetadata(Limits.getSOSLQueries(), Limits.getLimitSOSLQueries());
    }

    global class LimitUsageMetadata {

        @AuraEnabled global final Integer used {get; private set;}
        @AuraEnabled global final Integer max {get; private set;}

        global LimitUsageMetadata(Integer used, Integer max){
            this.used = used;
            this.max  = max;
        }

    }

}