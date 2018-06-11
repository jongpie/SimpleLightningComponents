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
        System.assertEquals(RestContext.request != null, contextMetadata.IsApexRest);
        System.assertEquals(System.isBatch(), contextMetadata.IsBatch);
        System.assertEquals(Trigger.isExecuting, contextMetadata.IsExecuting);
        System.assertEquals(System.isFuture(), contextMetadata.IsFuture);
        System.assertEquals(UserInfo.getUiThemeDisplayed() == 'Theme4d', contextMetadata.IsLightning);
        System.assertEquals(UserInfo.getUiThemeDisplayed() == 'Theme4u', contextMetadata.IsLightningConsole);
        System.assertEquals(System.isQueueable(), contextMetadata.IsQueueable);
        System.assertEquals(UserInfo.getUiThemeDisplayed() == 'Theme4t', contextMetadata.IsSalesforce1);
        System.assertEquals(System.isScheduled(), contextMetadata.IsScheduled);
        System.assertEquals(ApexPages.currentPage() != null, contextMetadata.IsVisualforce);
    }

    private static void validateCaseSentivityForJavascript(ContextMetadata contextMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonContextMetadata = JSON.serialize(contextMetadata);
        Map<String, Object> untypedContextMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonContextMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedContextMetadata.containsKey('ISAPEXREST') == false);
        // Now for the 'real' tests
        System.assert(untypedContextMetadata.containsKey('IsApexRest'));
        System.assert(untypedContextMetadata.containsKey('IsBatch'));
        System.assert(untypedContextMetadata.containsKey('IsExecuting'));
        System.assert(untypedContextMetadata.containsKey('IsFuture'));
        System.assert(untypedContextMetadata.containsKey('IsLightning'));
        System.assert(untypedContextMetadata.containsKey('IsLightningConsole'));
        System.assert(untypedContextMetadata.containsKey('IsQueueable'));
        System.assert(untypedContextMetadata.containsKey('IsSalesforce1'));
        System.assert(untypedContextMetadata.containsKey('IsScheduled'));
        System.assert(untypedContextMetadata.containsKey('IsVisualforce'));
    }

}