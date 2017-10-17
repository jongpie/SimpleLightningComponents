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

## objectPropertyValue.cmp
* Displays the specified property of any javascript object - this is helpful since Lightning does not allow you to dynamically get a property value by name (like 'myObject[someProperty]')

    `<c:objectPropertyValue object="{!v.my.complex.nested.object}" propertyName="someProperty" />`

# Apex Classes
Two Apex classes are included in this repo. Future updates will try to keep the number of custom classes to a minumum so this library remains lightweight.

## LightningDataController.cls
Contains methods for accessing and modifying data. All methods are designed to work with any SObject type.
* createNewRecord(String sobjectName) - returns a new SObject record of the specified type - any default field values are populated on fields that the current user can modify (based on the field describe's isCreateable())
* queryRecords(String parameterString) - accepts a serialized version of LightningDataController.QueryParameters and returns the SOQL results of the dynamic query
* insertRecords(List<SObject> records) - inserts & returns the provided records
* updateRecords(List<SObject> records) - updates & returns the provided records
* upsertRecords(List<SObject> records) - upserts & returns the provided records
* deleteRecords(List<SObject> records) - deletes the provided records, no return value
* hardDeleteRecords(List<SObject> records) - hard deletes the provided records, no return value
* undeleteRecords(List<SObject> records) - undeletes the provided records, no return value

## LightningMetadataController.cls
Contains methods for describing your orgs metadata and returning the info as aura-friendly objects that can be consumed by Lightning Components
* getSObjectMetadata(String sobjectName) - returns an instance of LightningMetadataController.SObjectMetadata
* getFieldMetadata(String sobjectName, String fieldName) - returns an instance of LightningMetadataController.FieldMetadata