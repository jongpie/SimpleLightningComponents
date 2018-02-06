/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class ContextMetadata_Tests {

    @isTest
    static void it_should_return_context_metadata() {
        ContextMetadata contextMetadata = new ContextMetadata();
        validateAttributesAreSet(contextMetadata);
        validateCaseSentivityForJavascript(contextMetadata);
    }

    private static void validateAttributesAreSet(ContextMetadata contextMetadata) {
        System.assertEquals(RestContext.request != null, contextMetadata.isApexRest);
        System.assertEquals(System.isBatch(), contextMetadata.isBatch);
        System.assertEquals(Trigger.isExecuting, contextMetadata.isExecuting);
        System.assertEquals(System.isFuture(), contextMetadata.isFuture);
        System.assertEquals(UserInfo.getUiThemeDisplayed() == 'Theme4d', contextMetadata.isLightning);
        System.assertEquals(UserInfo.getUiThemeDisplayed() == 'Theme4u', contextMetadata.isLightningConsole);
        System.assertEquals(System.isQueueable(), contextMetadata.isQueueable);
        System.assertEquals(UserInfo.getUiThemeDisplayed() == 'Theme4t', contextMetadata.isSalesforce1);
        System.assertEquals(System.isScheduled(), contextMetadata.isScheduled);
        System.assertEquals(ApexPages.currentPage() != null, contextMetadata.isVisualforce);
    }

    private static void validateCaseSentivityForJavascript(ContextMetadata contextMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonContextMetadata = JSON.serialize(contextMetadata);
        Map<String, Object> untypedContextMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonContextMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedContextMetadata.containsKey('ISAPEXREST') == false);
        // Now for the 'real' tests
        System.assert(untypedContextMetadata.containsKey('isApexRest'));
        System.assert(untypedContextMetadata.containsKey('isBatch'));
        System.assert(untypedContextMetadata.containsKey('isExecuting'));
        System.assert(untypedContextMetadata.containsKey('isFuture'));
        System.assert(untypedContextMetadata.containsKey('isLightning'));
        System.assert(untypedContextMetadata.containsKey('isLightningConsole'));
        System.assert(untypedContextMetadata.containsKey('isQueueable'));
        System.assert(untypedContextMetadata.containsKey('isSalesforce1'));
        System.assert(untypedContextMetadata.containsKey('isScheduled'));
        System.assert(untypedContextMetadata.containsKey('isVisualforce'));
    }

}