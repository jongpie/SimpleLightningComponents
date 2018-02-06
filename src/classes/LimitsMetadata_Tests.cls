/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class LimitsMetadata_Tests {

    @isTest
    static void it_should_return_limits_metadata() {
        LimitsMetadata limitsMetadata = new LimitsMetadata();
        validateAttributesAreSet(limitsMetadata);
        validateCaseSentivityForJavascript(limitsMetadata);
    }

    private static void validateAttributesAreSet(LimitsMetadata limitsMetadata) {
        System.assertEquals(Limits.getAggregateQueries(), limitsMetadata.aggregateQueries.used);
        System.assertEquals(Limits.getLimitAggregateQueries(), limitsMetadata.aggregateQueries.max);
        System.assertEquals(Limits.getAsyncCalls(), limitsMetadata.asyncCalls.used);
        System.assertEquals(Limits.getLimitAsyncCalls(), limitsMetadata.asyncCalls.max);
        System.assertEquals(Limits.getCallouts(), limitsMetadata.callouts.used);
        System.assertEquals(Limits.getLimitCallouts(), limitsMetadata.callouts.max);
        //System.assertEquals(Limits.getCPUTime(), limitsMetadata.cpuTime.used);
        System.assertEquals(Limits.getLimitCPUTime(), limitsMetadata.cpuTime.max);
        System.assertEquals(Limits.getDMLRows(), limitsMetadata.dmlRows.used);
        System.assertEquals(Limits.getLimitDMLRows(), limitsMetadata.dmlRows.max);
        System.assertEquals(Limits.getDMLStatements(), limitsMetadata.dmlStatements.used);
        System.assertEquals(Limits.getLimitDMLStatements(), limitsMetadata.dmlStatements.max);
        System.assertEquals(Limits.getEmailInvocations(), limitsMetadata.emailInvocations.used);
        System.assertEquals(Limits.getLimitEmailInvocations(), limitsMetadata.emailInvocations.max);
        System.assertEquals(Limits.getFutureCalls(), limitsMetadata.futureCalls.used);
        System.assertEquals(Limits.getLimitFutureCalls(), limitsMetadata.futureCalls.max);
        //System.assertEquals(Limits.getHeapSize(), limitsMetadata.heapSize.used);
        System.assertEquals(Limits.getLimitHeapSize(), limitsMetadata.heapSize.max);
        System.assertEquals(Limits.getMobilePushApexCalls(), limitsMetadata.mobilePushApexCalls.used);
        System.assertEquals(Limits.getLimitMobilePushApexCalls(), limitsMetadata.mobilePushApexCalls.max);
        System.assertEquals(Limits.getQueries(), limitsMetadata.queries.used);
        System.assertEquals(Limits.getLimitQueries(), limitsMetadata.queries.max);
        System.assertEquals(Limits.getQueryLocatorRows(), limitsMetadata.queryLocatorRows.used);
        System.assertEquals(Limits.getLimitQueryLocatorRows(), limitsMetadata.queryLocatorRows.max);
        System.assertEquals(Limits.getQueryRows(), limitsMetadata.queryRows.used);
        System.assertEquals(Limits.getLimitQueryRows(), limitsMetadata.queryRows.max);
        System.assertEquals(Limits.getQueueableJobs(), limitsMetadata.queueableJobs.used);
        System.assertEquals(Limits.getLimitQueueableJobs(), limitsMetadata.queueableJobs.max);
        System.assertEquals(Limits.getSOSLQueries(), limitsMetadata.soslQueries.used);
        System.assertEquals(Limits.getLimitSOSLQueries(), limitsMetadata.soslQueries.max);
    }

    private static void validateCaseSentivityForJavascript(LimitsMetadata limitsMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonLimitsMetadata = JSON.serialize(limitsMetadata);
        Map<String, Object> untypedLimitsMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonLimitsMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedLimitsMetadata.containsKey('AGGREGATEQUERIES') == false);
        // Now for the 'real' tests
        System.assert(untypedLimitsMetadata.containsKey('aggregateQueries'));
        System.assert(untypedLimitsMetadata.containsKey('asyncCalls'));
        System.assert(untypedLimitsMetadata.containsKey('callouts'));
        System.assert(untypedLimitsMetadata.containsKey('cpuTime'));
        System.assert(untypedLimitsMetadata.containsKey('dmlRows'));
        System.assert(untypedLimitsMetadata.containsKey('dmlStatements'));
        System.assert(untypedLimitsMetadata.containsKey('emailInvocations'));
        System.assert(untypedLimitsMetadata.containsKey('futureCalls'));
        System.assert(untypedLimitsMetadata.containsKey('heapSize'));
        System.assert(untypedLimitsMetadata.containsKey('mobilePushApexCalls'));
        System.assert(untypedLimitsMetadata.containsKey('queries'));
        System.assert(untypedLimitsMetadata.containsKey('queryLocatorRows'));
        System.assert(untypedLimitsMetadata.containsKey('queryRows'));
        System.assert(untypedLimitsMetadata.containsKey('queueableJobs'));
        System.assert(untypedLimitsMetadata.containsKey('soslQueries'));
    }

}