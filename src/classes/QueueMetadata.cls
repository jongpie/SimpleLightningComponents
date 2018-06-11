/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
global class QueueMetadata {

    // Stores cached query results
    private static final Map<Id, Group> QUERIED_QUEUES_BY_ID;
    private static final Map<String, Group> QUERIED_QUEUES_BY_DEVELOPER_NAME;

    static {
        // Query & cache queues
        QUERIED_QUEUES_BY_ID             = new Map<Id, Group>();
        QUERIED_QUEUES_BY_DEVELOPER_NAME = new Map<String, Group>();

        for(Group queue : [
            SELECT DeveloperName, DoesIncludeBosses, DoesSendEmailToMembers, Email, Id, Name,
                (SELECT SobjectType FROM QueueSobjects),
                (SELECT Id, GroupId, UserOrGroupId FROM GroupMembers)
            FROM Group
            WHERE Type = 'Queue'
        ]) {
            QUERIED_QUEUES_BY_ID.put(queue.Id, queue);
            QUERIED_QUEUES_BY_DEVELOPER_NAME.put(queue.DeveloperName, queue);
        }
    }

    public static List<String> getQueueApiNames() {
        List<String> queueApiNames = new List<String>(QUERIED_QUEUES_BY_DEVELOPER_NAME.keySet());
        queueApiNames.sort();
        return queueApiNames;
    }

    @AuraEnabled global final String ApiName                         {get; private set;}
    @AuraEnabled global final Boolean DoesIncludeBosses              {get; private set;}
    @AuraEnabled global final Boolean DoesSendEmailToMembers         {get; private set;}
    @AuraEnabled global final String Email                           {get; private set;}
    @AuraEnabled global final Id Id                                  {get; private set;}
    @AuraEnabled global final String Label                           {get; private set;}
    @AuraEnabled global final List<QueueMemberMetadata> QueueMembers {get; private set;}
    @AuraEnabled global final List<String> SobjectApiNames           {get; private set;}

    global QueueMetadata(String queueApiName) {
        this(QUERIED_QUEUES_BY_DEVELOPER_NAME.get(queueApiName).Id);
    }

    global QueueMetadata(Id queueId) {
        Group queue = QUERIED_QUEUES_BY_ID.get(queueId);

        this.ApiName                  = queue.DeveloperName;
        this.DoesIncludeBosses        = queue.DoesIncludeBosses;
        this.DoesSendEmailToMembers   = queue.DoesSendEmailToMembers;
        this.Email                    = queue.Email;
        this.Id                       = queue.Id;
        this.Label                    = queue.Name;
        this.QueueMembers             = this.getQueueMembers(queue);
        this.SobjectApiNames          = this.getSobjectApiNames(queue);
    }

    private List<QueueMemberMetadata> getQueueMembers(Group queue) {
        List<QueueMemberMetadata> queueMembers = new List<QueueMemberMetadata>();
        for(GroupMember queueMember : queue.GroupMembers) {
            queueMembers.add(new QueueMemberMetadata(queueMember));
        }
        queueMembers.sort();
        return queueMembers;
    }

    private List<String> getSobjectApiNames(Group queue) {
        List<String> sobjectApiNames = new List<String>();
        for(QueueSobject queueSobject : queue.QueueSobjects) {
            sobjectApiNames.add(queueSobject.SobjectType);
        }
        sobjectApiNames.sort();
        return sobjectApiNames;
    }

    global class QueueMemberMetadata implements Comparable {

        @AuraEnabled global final Id Id            {get; private set;}
        @AuraEnabled global final Id QueueId       {get; private set;}
        @AuraEnabled global final String Type      {get; private set;}
        @AuraEnabled global final Id UserOrGroupId {get; private set;}

        global Integer compareTo(Object compareTo) {
            QueueMemberMetadata compareToQueueMember = (QueueMemberMetadata)compareTo;

            if(this.UserOrGroupId == compareToQueueMember.UserOrGroupId) return 0;
            else if(this.UserOrGroupId > compareToQueueMember.UserOrGroupId) return 1;
            else return -1;
        }

        private QueueMemberMetadata(GroupMember groupMember) {
            this.Id            = groupMember.Id;
            this.QueueId       = groupMember.GroupId;
            this.Type          = String.valueOf(groupMember.UserOrGroupId.getSobjectType());
            this.UserOrGroupId = groupMember.UserOrGroupId;
        }

    }

}