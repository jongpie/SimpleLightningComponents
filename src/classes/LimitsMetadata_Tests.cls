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
        System.assertEquals(Limits.getAggregateQueries(), limitsMetadata.AggregateQueries.Used);
        System.assertEquals(Limits.getLimitAggregateQueries(), limitsMetadata.AggregateQueries.Max);
        System.assertEquals(Limits.getAsyncCalls(), limitsMetadata.AsyncCalls.Used);
        System.assertEquals(Limits.getLimitAsyncCalls(), limitsMetadata.AsyncCalls.Max);
        System.assertEquals(Limits.getCallouts(), limitsMetadata.Callouts.Used);
        System.assertEquals(Limits.getLimitCallouts(), limitsMetadata.Callouts.Max);
        //System.assertEquals(Limits.getCPUTime(), limitsMetadata.CpuTime.Used);
        System.assertEquals(Limits.getLimitCPUTime(), limitsMetadata.CpuTime.Max);
        System.assertEquals(Limits.getDMLRows(), limitsMetadata.DmlRows.Used);
        System.assertEquals(Limits.getLimitDMLRows(), limitsMetadata.DmlRows.Max);
        System.assertEquals(Limits.getDMLStatements(), limitsMetadata.DmlStatements.Used);
        System.assertEquals(Limits.getLimitDMLStatements(), limitsMetadata.DmlStatements.Max);
        System.assertEquals(Limits.getEmailInvocations(), limitsMetadata.EmailInvocations.Used);
        System.assertEquals(Limits.getLimitEmailInvocations(), limitsMetadata.EmailInvocations.Max);
        System.assertEquals(Limits.getFutureCalls(), limitsMetadata.FutureCalls.Used);
        System.assertEquals(Limits.getLimitFutureCalls(), limitsMetadata.FutureCalls.Max);
        //System.assertEquals(Limits.getHeapSize(), limitsMetadata.HeapSize.Used);
        System.assertEquals(Limits.getLimitHeapSize(), limitsMetadata.HeapSize.Max);
        System.assertEquals(Limits.getMobilePushApexCalls(), limitsMetadata.MobilePushApexCalls.Used);
        System.assertEquals(Limits.getLimitMobilePushApexCalls(), limitsMetadata.MobilePushApexCalls.Max);
        System.assertEquals(Limits.getQueueableJobs(), limitsMetadata.QueueableJobs.Used);
        System.assertEquals(Limits.getLimitQueueableJobs(), limitsMetadata.QueueableJobs.Max);
        System.assertEquals(Limits.getQueries(), limitsMetadata.SoqlQueries.Used);
        System.assertEquals(Limits.getLimitQueries(), limitsMetadata.SoqlQueries.Max);
        System.assertEquals(Limits.getQueryLocatorRows(), limitsMetadata.SoqlQueryLocatorRows.Used);
        System.assertEquals(Limits.getLimitQueryLocatorRows(), limitsMetadata.SoqlQueryLocatorRows.Max);
        System.assertEquals(Limits.getQueryRows(), limitsMetadata.SoqlQueryRows.Used);
        System.assertEquals(Limits.getLimitQueryRows(), limitsMetadata.SoqlQueryRows.Max);
        System.assertEquals(Limits.getSOSLQueries(), limitsMetadata.SoslSearches.Used);
        System.assertEquals(Limits.getLimitSoslQueries(), limitsMetadata.SoslSearches.Max);
    }

    private static void validateCaseSentivityForJavascript(LimitsMetadata limitsMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonLimitsMetadata = JSON.serialize(limitsMetadata);
        Map<String, Object> untypedLimitsMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonLimitsMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedLimitsMetadata.containsKey('AGGREGATEQUERIES') == false);
        // Now for the 'real' tests
        System.assert(untypedLimitsMetadata.containsKey('AggregateQueries'));
        System.assert(untypedLimitsMetadata.containsKey('AsyncCalls'));
        System.assert(untypedLimitsMetadata.containsKey('Callouts'));
        System.assert(untypedLimitsMetadata.containsKey('CpuTime'));
        System.assert(untypedLimitsMetadata.containsKey('DmlRows'));
        System.assert(untypedLimitsMetadata.containsKey('DmlStatements'));
        System.assert(untypedLimitsMetadata.containsKey('EmailInvocations'));
        System.assert(untypedLimitsMetadata.containsKey('FutureCalls'));
        System.assert(untypedLimitsMetadata.containsKey('HeapSize'));
        System.assert(untypedLimitsMetadata.containsKey('MobilePushApexCalls'));
        System.assert(untypedLimitsMetadata.containsKey('QueueableJobs'));
        System.assert(untypedLimitsMetadata.containsKey('SoqlQueries'));
        System.assert(untypedLimitsMetadata.containsKey('SoqlQueryLocatorRows'));
        System.assert(untypedLimitsMetadata.containsKey('SoqlQueryRows'));
        System.assert(untypedLimitsMetadata.containsKey('SoslSearches'));
    }

}