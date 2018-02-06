/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global virtual class ProfileMetadata {

    // Stores cached query results
    private static final Map<Id, Profile> QUERIED_PROFILES_BY_ID;
    private static final Map<String, Profile> QUERIED_PROFILES_BY_LABEL;

    static {
        // Query & cache profiles
        QUERIED_PROFILES_BY_ID    = new Map<Id, Profile>();
        QUERIED_PROFILES_BY_LABEL = new Map<String, Profile>();

        for(Profile profile : [SELECT Id, Name, Description, UserLicenseId, UserLicense.Name, UserType FROM Profile]) {
            QUERIED_PROFILES_BY_ID.put(profile.Id, profile);
            QUERIED_PROFILES_BY_LABEL.put(profile.Name, profile);
        }
    }

    @AuraEnabled global final Id id                  {get; private set;}
    @AuraEnabled global final String label           {get; private set;}
    //@AuraEnabled global final Id userLicenseId       {get; private set;}
    //@AuraEnabled global final String userLicenseName {get; private set;}
    @AuraEnabled global final String userType        {get; private set;}

    global ProfileMetadata(Id profileId) {
        Profile profile = QUERIED_PROFILES_BY_ID.get(profileId);

        this.id              = profile.Id;
        this.label           = profile.Name;
        //this.userLicenseId   = profile.userLicenseId;
        //this.userLicenseName = profile.UserLicense.Name;
        this.userType        = profile.UserType;
    }

}