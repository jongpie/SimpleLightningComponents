# Lightning Components
A collection of custom Salesforce Lightning components to try to make Lightning development a little bit less frustrating

## lightningData.cmp
* A service component that dynamically queries any SObject

    `<c:lightningData sobjectType="Account" fields="Id,Name,MyCustomField__c" />`
* Feature: Field level security is automatically enforced by default - only fields that the current user has access to read (based on field.isAccessible()) will be returned. When false, all fields specified in the "fields" attribute are returned, regardless of field level security settings.

    `<c:lightningData sobjectType="Account" fields="Id,Name,MyCustomField__c" enforceFLS="false" />`
* Feature: Query caching can be enabled. When true, the Lightning component will cache the results for subsequent calls (action.setStorable())

    `<c:lightningData sobjectType="Account" fields="Id,Name,MyCustomField__c" cacheResults="true" />`

## inputField.cmp
* Provides a simple way to display an SObject's field that automatically determines the field type, field label, etc. Attributes can be overridden to allow control over the field when needed

    `<c:inputField sobjectName="Account" record="{!v.myAccount}" fieldName="Type" />`

## fieldLabel.cmp
* Displays the localized version of the provided field's label

    `<c:fieldLabel sobjectName="Account" fieldName="Type" />`

* Feature: Show the field's inline help text

    `<c:fieldLabel sobjectName="Account" fieldName="Type" showHelpText="true" />`
## sobjectLabel.cmp
* Displays the localized version of the provided SObject's label

    `<c:sobjectLabel sobjectName="Account" />`

* Feature: Show the SObject's plural label

    `<c:sobjectLabel sobjectName="Account" variant="labelPlural" />`
## modal.cmp
* Generates a modal window and displays your contents inside
    ```
    <c:modal title="My Modal" isOpen="{!v.showModal}">
        <aura:set attribute="body">
            <p>This paragraph will be shown inside the modal</p>
        </aura:set>
    </c:modal>
    ```