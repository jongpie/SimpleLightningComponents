# Lightning Components
A collection of custom Salesforce Lightning components to try to make Lightning development a little bit less frustrating

## inputField.cmp
* Provides a simple way to display an SObject's field that automatically determines the field type, field label, etc. Attributes can be overridden to allow control over the field when needed
    `<c:inputField sobjectName="Account" record="{!v.myAccount}" fieldName="Type" />`

## fieldLabel.cmp
* Displays the localized version of the provided field's label
    `<c:fieldLabel sobjectName="Account" fieldName="Type" />`
## sobjectLabel.cmp
* Displays the localized version of the provided SObject's label
    `<c:sobjectLabel sobjectName="Account" />`

## modal.cmp
* Generates a modal window and displays your contents inside
    ```
    <c:modal title="My Modal" isOpen="{!v.showModal}">
        <aura:set attribute="body">
            <p>This paragraph will be shown inside the modal</p>
        </aura:set>
    </c:modal>
    ```