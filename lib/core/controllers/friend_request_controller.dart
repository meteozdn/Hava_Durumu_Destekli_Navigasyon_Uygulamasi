import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/core/controllers/chat_group_controller.dart';
import 'package:navigationapp/core/controllers/user_controller.dart';
import 'package:navigationapp/core/models/friend_request.dart';

class FriendRequestController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void sendFriendRequest({
    required String senderId,
    required String recipientId,
  }) async {
    try {
      // Create friendRequest model.
      FriendRequest friendRequest = FriendRequest(
        id: senderId + recipientId,
        senderId: senderId,
        recipientId: recipientId,
      );
      // Save friendRequest to Firestore.
      await firestore
          .collection(FirestoreCollections.friendRequests)
          .doc(friendRequest.id)
          .set(friendRequest.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  void acceptFriendRequest({
    required String senderId,
    required String recipientId,
  }) async {
    try {
      // Add sender to recipient's friend list.
      Get.find<UserController>()
          .updateUserFriendList(userId: recipientId, friendId: senderId);
      // Add recipient to sender's friend list.
      Get.find<UserController>()
          .updateUserFriendList(userId: senderId, friendId: recipientId);
      // Create chatGroup.
      Get.find<ChatGroupController>()
          .createChatGroup(members: [senderId, recipientId]);
      // Delete the friend request document.
      deleteFriendRequest(senderId: senderId, recipientId: recipientId);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> deleteFriendRequest({
    required String senderId,
    required String recipientId,
  }) async {
    try {
      await firestore
          .collection(FirestoreCollections.friendRequests)
          .doc(senderId + recipientId)
          .delete();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<String> getFriendState({required String friendId}) async {
    List<Future<void>> futures = [];
    String text = "AddFriend";
    // If user already sent friend request.
    futures.add(_getFriendRequestSnapshot(
            senderId: Get.find<UserController>().user.value!.id,
            recipientId: friendId)
        .then((value) {
      if (value!.docs.isNotEmpty) {
        text = "RemoveRequest";
      }
    }));
    // If user already received friend request.
    futures.add(_getFriendRequestSnapshot(
            senderId: friendId,
            recipientId: Get.find<UserController>().user.value!.id)
        .then((value) {
      if (value!.docs.isNotEmpty) {
        text = "AcceptRequest";
      }
    }));
    futures.add(Get.find<UserController>()
        .fetchUser(userId: Get.find<UserController>().user.value!.id)
        .then((value) {
      if (value.friends!.contains(friendId)) {
        text = "RemoveFriend";
      }
    }));
    await Future.wait(futures);
    return text;
  }

  Future<QuerySnapshot?> _getFriendRequestSnapshot({
    required String senderId,
    required String recipientId,
  }) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(FirestoreCollections.friendRequests)
        .where("senderId", isEqualTo: senderId)
        .where("recipientId", isEqualTo: recipientId)
        .get();
    return querySnapshot;
  }
}
