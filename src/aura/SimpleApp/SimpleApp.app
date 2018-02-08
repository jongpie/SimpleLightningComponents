<aura:application extends="force:slds">

    <!-- Public attributes -->
    <aura:attribute name="myAccount" type="Account" default="{}" />
    <aura:attribute name="myTask" type="Task" default="{}" />

    <!-- Private attributes -->
    <aura:attribute name="environmentMetadata" type="EnvironmentMetadata" access="private" />
    <aura:attribute name="currentUser" type="User" access="private" />
    <aura:attribute name="sobjectMetadata" type="SObjectMetadata" access="private" />
    <aura:attribute name="selectedSObject" type="String" access="private" />

    <!-- Metadata service components -->
    <c:environmentMetadata aura:id="environmentMetadataService" />
    <c:currentUser aura:id="currentUserService" />
    <c:sobjectMetadata aura:id="sobjectMetadataService" sobjectApiName="{!v.selectedSObject}" />

    <!-- Handlers -->
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>

    <!-- Markup -->
    <h1 class="slds-align_absolute-center" style="font-size:250%;font-weight:bold;margin-bottom:30px;">Simple Lightning Components</h1>
    <lightning:tabset>
        <lightning:tab label="Environment Metadata">
            <h2 style="font-size:150%;font-weight:bold;margin-bottom:20px;">Environment Metadata</h2>
            <table class="slds-table slds-table_bordered slds-table_cell-buffer slds-table_striped">
                <thead>
                    <tr class="slds-text-title_caps ">
                        <th scope="col"><div class="slds-truncate">Attribute</div></th>
                        <th scope="col"><div class="slds-truncate">Value</div></th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td>baseUrl</td><td>{!v.environmentMetadata.baseUrl}</td></tr>
                    <tr><td>instanceName</td><td>{!v.environmentMetadata.instanceName}</td></tr>
                    <tr><td>isChatterEnabled</td><td style="{!v.environmentMetadata.isChatterEnabled ? 'color:green' : 'color:red'}">{!v.environmentMetadata.isChatterEnabled}</td></tr>
                    <tr><td>isKnowledgeEnabled</td><td style="{!v.environmentMetadata.isKnowledgeEnabled == true ? 'color:green' : 'color:red'}">{!v.environmentMetadata.isKnowledgeEnabled}</td></tr>
                    <tr><td>isMultiCurrencyEnabled</td><td style="{!v.environmentMetadata.isMultiCurrencyEnabled == true ? 'color:green' : 'color:red'}">{!v.environmentMetadata.isMultiCurrencyEnabled}</td></tr>
                    <tr><td>isPersonAccountEnabled</td><td style="{!v.environmentMetadata.isPersonAccountEnabled == true ? 'color:green' : 'color:red'}">{!v.environmentMetadata.isPersonAccountEnabled}</td></tr>
                    <tr><td>isProduction</td><td style="{!v.environmentMetadata.isProduction == true ? 'color:green' : 'color:red'}">{!v.environmentMetadata.isProduction}</td></tr>
                    <tr><td>isSandbox</td><td style="{!v.environmentMetadata.isSandbox == true ? 'color:green' : 'color:red'}">{!v.environmentMetadata.isSandbox}</td></tr>
                    <tr><td>isTerritoryManagementEnabled</td><td style="{!v.environmentMetadata.isTerritoryManagementEnabled == true ? 'color:green' : 'color:red'}">{!v.environmentMetadata.isTerritoryManagementEnabled}</td></tr>
                    <tr><td>namespace</td><td>{!v.environmentMetadata.namespace}</td></tr>
                    <tr><td>organizationId</td><td>{!v.environmentMetadata.organizationId}</td></tr>
                    <tr><td>organizationName</td><td>{!v.environmentMetadata.organizationName}</td></tr>
                    <tr><td>organizationType</td><td>{!v.environmentMetadata.organizationType}</td></tr>
                    <tr>
                        <td>sobjectApiNames</td>
                        <td>
                            <ul style="border:1px solid #000; max-height:300px; overflow-y:scroll;">
                                <aura:iteration items="{!v.environmentMetadata.sobjectApiNames}" var="sobjectApiName">
                                    <li>{!sobjectApiName}</li>
                                </aura:iteration>
                            </ul>
                        </td>
                    </tr>
                </tbody>
            </table>
        </lightning:tab>
        <lightning:tab label="Current User">
            <h2 style="font-size:150%;font-weight:bold;margin-bottom:20px;">Current User</h2>
            <table class="slds-table slds-table_bordered slds-table_cell-buffer slds-table_striped">
                <thead>
                    <tr class="slds-text-title_caps ">
                        <th scope="col"><div class="slds-truncate">Current User: Fields &amp; Values</div></th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="DefaultCurrency" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="Email" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="FirstName" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="Id" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="Language" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="LastName" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="Locale" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="Name" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="ProfileId" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="Username" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="UserRoleId" record="{!v.currentUser}" /></td></tr>
                    <tr><td><c:outputField sobjectApiName="User" fieldApiName="UserType" record="{!v.currentUser}" /></td></tr>
                </tbody>
            </table>
        </lightning:tab>
        <lightning:tab label="SObject Metadata">
            <h2 style="font-size:150%;font-weight:bold;margin-bottom:20px;">SObject Metadata</h2>
            <lightning:select name="selectItem" label="Select an SObject" value="{!v.selectedSObject}" onchange="{!c.fetchSObjectMetadata}">
                <option value="" text="" />
                <aura:iteration items="{!v.environmentMetadata.sobjectApiNames}" var="sobjectApiName">
                    <option value="{!sobjectApiName}" text="{!sobjectApiName}" />
                </aura:iteration>
            </lightning:select>
            <aura:if isTrue="{!empty(v.selectedSObject) == false}">
                <table class="slds-table slds-table_bordered slds-table_cell-buffer slds-table_striped">
                    <thead>
                        <tr class="slds-text-title_caps ">
                            <th scope="col" style="width:50%"><div class="slds-truncate">Attribute</div></th>
                            <th scope="col" style="width:50%"><div class="slds-truncate">Value</div></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td>apiName</td><td>{!v.sobjectMetadata.apiName}</td></tr>
                        <tr><td>displayFieldApiName</td><td>{!v.sobjectMetadata.displayFieldApiName}</td></tr>
                        <tr><td>hasMultiCurrency</td><td style="{!v.sobjectMetadata.hasMultiCurrency ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.hasMultiCurrency}</td></tr>
                        <tr><td>hasSubtypes</td><td style="{!v.sobjectMetadata.hasSubtypes ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.hasSubtypes}</td></tr>
                        <tr><td>isAccessible</td><td style="{!v.sobjectMetadata.isAccessible ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isAccessible}</td></tr>
                        <tr><td>isChatterFeedEnabled</td><td style="{!v.sobjectMetadata.isChatterFeedEnabled ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isChatterFeedEnabled}</td></tr>
                        <tr><td>isCreateable</td><td style="{!v.sobjectMetadata.isCreateable ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isCreateable}</td></tr>
                        <tr><td>isCustom</td><td style="{!v.sobjectMetadata.isCustom ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isCustom}</td></tr>
                        <tr><td>isCustomSetting</td><td style="{!v.sobjectMetadata.isCustomSetting ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isCustomSetting}</td></tr>
                        <tr><td>isDeletable</td><td style="{!v.sobjectMetadata.isDeletable ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isDeletable}</td></tr>
                        <tr><td>isMruEnabled</td><td style="{!v.sobjectMetadata.isMruEnabled ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isMruEnabled}</td></tr>
                        <tr><td>isMergeable</td><td style="{!v.sobjectMetadata.isMergeable ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isMergeable}</td></tr>
                        <tr><td>isQueryable</td><td style="{!v.sobjectMetadata.isQueryable ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isQueryable}</td></tr>
                        <tr><td>isSearchable</td><td style="{!v.sobjectMetadata.isSearchable ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isSearchable}</td></tr>
                        <tr><td>isUndeletable</td><td style="{!v.sobjectMetadata.isUndeletable ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isUndeletable}</td></tr>
                        <tr><td>isUpdateable</td><td style="{!v.sobjectMetadata.isUpdateable ? 'color:green' : 'color:red'}">{!v.sobjectMetadata.isUpdateable}</td></tr>
                        <tr>
                            <td>fieldApiNames</td>
                            <td>
                                <ul style="border:1px solid #000; max-height:300px; overflow-y:scroll;">
                                    <aura:iteration items="{!v.sobjectMetadata.fieldApiNames}" var="fieldApiName">
                                        <li>{!fieldApiName}</li>
                                    </aura:iteration>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>fieldSetApiNames</td>
                            <td>
                                <ul style="border:1px solid #000; max-height:300px; overflow-y:scroll;">
                                    <aura:iteration items="{!v.sobjectMetadata.fieldSetApiNames}" var="fieldSetApiName">
                                        <li>{!fieldSetApiName}</li>
                                    </aura:iteration>
                                </ul>
                            </td>
                        </tr>
                        <tr><td>keyPrefix</td><td>{!v.sobjectMetadata.keyPrefix}</td></tr>
                        <tr><td>label</td><td>{!v.sobjectMetadata.label}</td></tr>
                        <tr><td>labelPlural</td><td>{!v.sobjectMetadata.labelPlural}</td></tr>
                        <tr>
                            <td>listViewApiNames</td>
                            <td>
                                <ul style="border:1px solid #000; max-height:300px; overflow-y:scroll;">
                                    <aura:iteration items="{!v.sobjectMetadata.listViewApiNames}" var="listViewApiName">
                                        <li>{!listViewApiName}</li>
                                    </aura:iteration>
                                </ul>
                            </td>
                        </tr>
                        <tr><td>localApiName</td><td>{!v.sobjectMetadata.localApiName}</td></tr>
                        <tr><td>namespace</td><td>{!v.sobjectMetadata.namespace}</td></tr>
                        <tr>
                            <td>recordTypeApiNames</td>
                            <td>
                                <ul style="border:1px solid #000; max-height:300px; overflow-y:scroll;">
                                    <aura:iteration items="{!v.sobjectMetadata.recordTypeApiNames}" var="recordTypeApiName">
                                        <li>{!recordTypeApiName}</li>
                                    </aura:iteration>
                                </ul>
                            </td>
                        </tr>
                        <tr><td>tabIcon</td><td>{!v.sobjectMetadata.tabIcon}</td></tr>
                    </tbody>
                </table>
            </aura:if>
        </lightning:tab>
        <lightning:tab label="Record Edit Demo">
            <div style="padding: 1.0rem; background: rgb(22, 50, 92) none repeat scroll 0% 0%;">
                <div class="slds-text-color_inverse">
                    <p>This section provides demos of editing some account and task fields to show how your org metadata is leveraged to display each field</p>
                </div>
            </div>
            <div class="slds-text-color_inverse">
            </div>
            <h2 style="font-size:150%;font-weight:bold;margin-bottom:20px;">
                SObject Account Label: <c:sobjectLabel sobjectApiName="Account" />
                (Plural: <c:sobjectLabel sobjectApiName="Account" variant="labelPlural" />)
            </h2>
            <div>
                <c:inputField sobjectApiName="Account" fieldApiName="Name" record="{!v.myAccount}" />
                <c:inputField sobjectApiName="Account" fieldApiName="Type" record="{!v.myAccount}" />
            </div>
            <br />
            <br />
            <br />
            <h2 style="font-size:150%;font-weight:bold;margin-bottom:20px;">
                SObject Task Label: <c:sobjectLabel sobjectApiName="Task" />
                (Plural: <c:sobjectLabel sobjectApiName="Task" variant="labelPlural" />)
            </h2>
            <div>
                <c:inputField sobjectApiName="Task" fieldApiName="WhoId" record="{!v.myTask}" />
                <c:inputField sobjectApiName="Task" fieldApiName="WhatId" record="{!v.myTask}" />
                <c:inputField sobjectApiName="Task" fieldApiName="OwnerId" record="{!v.myTask}" />
                <c:inputField sobjectApiName="Task" fieldApiName="IsReminderSet" record="{!v.myTask}" />
                <c:inputField sobjectApiName="Task" fieldApiName="CallType" record="{!v.myTask}" />
                <c:inputField sobjectApiName="Task" fieldApiName="Description" record="{!v.myTask}" />
            </div>
        </lightning:tab>
    </lightning:tabset>

</aura:application>