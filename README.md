# Simple Lightning Components
A library of lightweight Salesforce Lightning components that simplify developing in Lightning by automatically:
* Honoring SObject-level security & field-level security for displaying fields & allowing fields to be edited
* Displaying the correct input field type based on the field's metadata, including lookup fields & support for polymorphic fields like Task.WhoId & Task.WhatId
* Translating SObject labels, field labels and picklist options

<a href="https://githubsfdeploy.herokuapp.com" target="_blank">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Simple Admin component
* simpleAdmin.cmp - this is a demo component that provides examples of how to use the other components. It's also a handy admin tool to quickly get information about your org.

## Metadata Components
Several no-markup components are included. These can be used to dynamically access metadata about your org in Lightning components
* **currentUser.cmp**: return info about the current user. Additional user fields can be returned by setting currentUser.additionalFieldApiNames
* **environmentMetadata.cmp**: returns an instance of EnvironmentMetadata for the specified SObjectenvironmentMetadata.cmp
* **fieldMetadata.cmp**: returns an instance of FieldMetadata for the specified SObjectfieldMetadata.cmp
* **fieldSetMetadata.cmp**: returns an instance of FieldSetMetadata for the specified SObjectfieldSetMetadata.cmp
* **listviewMetadata.cmp**: returns an instance of ListviewMetadata for the specified SObjectlistviewMetadata.cmp
* **queueMetadata.cmp**: returns an instance of QueueMetadata for the specified SObjectqueueMetadata.cmp
* **recordTypeMetadata.cmp**: returns an instance of RecordTypeMetadata for the specified SObjectrecordTypeMetadata.cmp
* **sobjectMetadata.cmp**: returns an instance of SObjectMetadata for the specified SObjectsobjectMetadata.cmp

## UI Components
These components are used to build UIs in Lightning - several of these leverage the metadata service components
* **fieldLabel.cmp**: Displays the localized version of the provided field's label
* **inputField.cmp**: Provides a simple way to display an SObject's field as an input (editable) that automatically determines sobject-level security, field-level security, the field type, field label, etc. Attributes can be overridden to allow control over the field when needed
* **lookup.cmp**: Provides lookup functionality that Salesforce does not provide for developers in LEX. This component is used by inputField.cmp for lookup fields.
* **modal.cmp**: Generates a modal window and displays your contents inside
* **objectPropertyValue.cmp**: Displays the specified property of any javascript object - this is helpful since Lightning does not allow you to dynamically get a property value by name (like 'myObject[someProperty]')
* **outputField.cmp**: Provides a simple way to display an SObject's field as an output (read-only) that automatically determines sobject-level security, field-level security, the field type, field label, etc. Attributes can be overridden to allow control over the field when needed
* **sobjectLabel.cmp**: Displays the localized version of the provided SObject's label

## Apex Classes

### LightningMetadataController.cls
Contains methods for describing your orgs metadata and returning the info as aura-friendly objects that can be consumed by Lightning Components
* getSObjectMetadata(String sobjectName) - returns an instance of LightningMetadataController.SObjectMetadata
* getFieldMetadata(String sobjectName, String fieldName) - returns an instance of LightningMetadataController.FieldMetadata

### SimpleMetadata classes
The remaining metadata classes (SObjectMetadata.cls, FieldMetadata.cls, etc) are part of the [SimpleMetadata](https://github.com/jongpie/SimpleMetadata) project - any bugs or enhancements for those classes are maintained in that project, and the latest version is used in this repo.