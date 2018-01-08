# Lightning Components
A library of lightweight Salesforce Lightning components that streamline developing by automatically applying sobject-level security, field-level security, field types and more.

<a href="https://githubsfdeploy.herokuapp.com" target="_blank">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## sobjectMetadata.cmp
* An extensible, markup-less component that returns an instance of LightningMetadataController.SObjectMetadata for the specified SObject

    `<c:sobjectMetadata sobjectName="Account" aura:id="accountMetadataService" />`

## fieldMetadata.cmp
* An extensible, markup-less component that returns an instance of LightningMetadataController.FieldMetadata for the specified field

    `<c:fieldMetadata sobjectName="Account" fieldName="Type" aura:id="accountTypeMetadataService" />`

## inputField.cmp
* Provides a simple way to display an SObject's field as an input (editable) that automatically determines sobject-level security, field-level security, the field type, field label, etc. Attributes can be overridden to allow control over the field when needed

    `<c:inputField sobjectName="Account" fieldName="Type" record="{!v.myAccount}" />`

## lookup.cmp
* Provides lookup functionality that Salesforce does not provide for developers in LEX. This component is used by inputField.cmp for lookup fields.

    `<c:lookup sobjectName="Contact" fieldName="AccountId" record="{!v.myContact}" />`

## outputField.cmp
* Provides a simple way to display an SObject's field as an output (read-only) that automatically determines sobject-level security, field-level security, the field type, field label, etc. Attributes can be overridden to allow control over the field when needed

    `<c:inputField sobjectName="Account" fieldName="Type" record="{!v.myAccount}" />`

## sobjectLabel.cmp
* Displays the localized version of the provided SObject's label

    `<c:sobjectLabel sobjectName="Account" />`

* Feature: Show the SObject's plural label

    `<c:sobjectLabel sobjectName="Account" variant="labelPlural" />`

## fieldLabel.cmp
* Displays the localized version of the provided field's label

    `<c:fieldLabel sobjectName="Account" fieldName="Type" />`

* Feature: Show the field's inline help text

    `<c:fieldLabel sobjectName="Account" fieldName="Type" showHelpText="true" />`

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

## LightningMetadataController.cls
Contains methods for describing your orgs metadata and returning the info as aura-friendly objects that can be consumed by Lightning Components
* getSObjectMetadata(String sobjectName) - returns an instance of LightningMetadataController.SObjectMetadata
* getFieldMetadata(String sobjectName, String fieldName) - returns an instance of LightningMetadataController.FieldMetadata