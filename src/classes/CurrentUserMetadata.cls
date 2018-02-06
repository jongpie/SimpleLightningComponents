/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class CurrentUserMetadata {

    @AuraEnabled global final String defaultCurrency    {get; private set;}
    @AuraEnabled global final String email              {get; private set;}
    @AuraEnabled global final String firstName          {get; private set;}
    @AuraEnabled global final Id id                     {get; private set;}
    @AuraEnabled global final String language           {get; private set;}
    @AuraEnabled global final String lastName           {get; private set;}
    @AuraEnabled global final String locale             {get; private set;}
    @AuraEnabled global final String name               {get; private set;}
    @AuraEnabled global final Id profileId              {get; private set;}
    @AuraEnabled global final String username           {get; private set;}
    @AuraEnabled global final Id userRoleId             {get; private set;}
    @AuraEnabled global final String userType           {get; private set;}

    global CurrentUserMetadata() {
        this.defaultCurrency = UserInfo.getDefaultCurrency();
        this.email           = UserInfo.getUserEmail();
        this.firstName       = UserInfo.getFirstName();
        this.id              = UserInfo.getUserId();
        this.language        = UserInfo.getLanguage();
        this.lastName        = UserInfo.getLastName();
        this.locale          = UserInfo.getLocale();
        this.name            = UserInfo.getName();
        this.profileId       = UserInfo.getProfileId();
        this.username        = UserInfo.getUsername();
        this.userRoleId      = UserInfo.getUserRoleId();
        this.userType        = UserInfo.getUserType();
    }

}