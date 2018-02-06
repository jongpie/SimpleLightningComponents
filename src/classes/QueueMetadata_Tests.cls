/*************************************************************************************************
* This file is part of the SimpleMetadata project, released under the MIT License.               *
* See LICENSE file or go to https://github.com/jongpie/SimpleMetadata for full license details.  *
*************************************************************************************************/
@isTest
private class QueueMetadata_Tests {

    private static final String queueDeveloperName = 'queueDeveloperName';

    @testSetup
    static void testSetup() {
        // Create queue
        Group queue = new Group(DeveloperName = queueDeveloperName, Name = queueDeveloperName, Type = 'Queue');
        insert queue;

        // Create queue SObject
        QueueSObject queueCaseSObject = new QueueSObject(QueueId = queue.Id, SObjectType = 'Case');
        insert queueCaseSObject;

        // Create queue members
        List<GroupMember> queueMembers = new List<GroupMember>();
        for(User user : [SELECT Id FROM User WHERE IsActive = true AND Id != :UserInfo.getUserId()]) {
            GroupMember queueMember = new GroupMember(
                GroupId       = queue.Id,
                UserOrGroupId = UserInfo.getUserId()
            );
            queueMembers.add(queueMember);
        }
        insert queueMembers;
    }

    @isTest
    static void it_should_return_queue_metadata_for_id() {
        Group queue = getQueue();

        Test.startTest();

        QueueMetadata queueMetadata = new QueueMetadata(queue.Id);
        validateAttributesAreSet(queue, queueMetadata);
        validateCaseSentivityForJavascript(queueMetadata);

        Test.stopTest();
    }

    @isTest
    static void it_should_return_queue_metadata_for_api_name() {
        Group queue = getQueue();

        Test.startTest();

        QueueMetadata queueMetadata = new QueueMetadata(queue.DeveloperName);
        validateAttributesAreSet(queue, queueMetadata);
        validateCaseSentivityForJavascript(queueMetadata);

        Test.stopTest();
    }

    private static Group getQueue() {
        Group queue = [
            SELECT Id, Name, DeveloperName, DoesIncludeBosses, DoesSendEmailToMembers, Email, OwnerId, Owner.Name
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName = :queueDeveloperName
        ];
        return queue;
    }

    private static void validateAttributesAreSet(Group queue, QueueMetadata queueMetadata) {
        System.assertEquals(queue.DeveloperName, queueMetadata.apiName);
        System.assertEquals(queue.DoesIncludeBosses, queueMetadata.doesIncludeBosses);
        System.assertEquals(queue.DoesSendEmailToMembers, queueMetadata.doesSendEmailToMembers);
        System.assertEquals(queue.Email, queueMetadata.email);
        System.assertEquals(queue.Name, queueMetadata.label);
        System.assertEquals(queue.OwnerId, queueMetadata.ownerId);
        System.assertEquals(queue.Owner.Name, queueMetadata.ownerName);
        System.assertEquals(queue.Owner.Type, queueMetadata.ownerType);
        System.assertEquals(queue.Id, queueMetadata.id);
    }

    private static void validateCaseSentivityForJavascript(QueueMetadata queueMetadata) {
        // Validate that the attributes are named exactly as expected so that javascript can rely on them
        String jsonQueueMetadata = JSON.serialize(queueMetadata);
        Map<String, Object> untypedQueueMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonQueueMetadata);

        // One negative to confirm that the strings in our map are case sensitive
        System.assert(untypedQueueMetadata.containsKey('APINAME') == false);
        // Now for the 'real' tests
        System.assert(untypedQueueMetadata.containsKey('apiName'));
        System.assert(untypedQueueMetadata.containsKey('doesIncludeBosses'));
        System.assert(untypedQueueMetadata.containsKey('doesSendEmailToMembers'));
        System.assert(untypedQueueMetadata.containsKey('email'));
        System.assert(untypedQueueMetadata.containsKey('id'));
        System.assert(untypedQueueMetadata.containsKey('label'));
        System.assert(untypedQueueMetadata.containsKey('ownerId'));
        System.assert(untypedQueueMetadata.containsKey('ownerName'));
        System.assert(untypedQueueMetadata.containsKey('ownerType'));
        System.assert(untypedQueueMetadata.containsKey('supportedSObjectApiNames'));
        System.assert(untypedQueueMetadata.containsKey('queueMembers'));
    }

}