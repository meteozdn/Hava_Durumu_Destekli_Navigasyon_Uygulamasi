import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/models/friend_request.dart';
import 'package:navigationapp/models/user.dart';

class FriendRequestController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<FriendRequest> friendRequestsIn = <FriendRequest>[].obs;
  final RxList<FriendRequest> friendRequestsOut = <FriendRequest>[].obs;
  final RxList<User> friends = <User>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchFriendRequests();
  }

  Future<void> fetchFriendRequests() async {
    try {
      friendRequestsIn.clear();
      friendRequestsOut.clear();
      friends.clear();
      // Store user data to local.
      String currentUserId = Get.find<UserController>().user.value!.id;
      await Get.find<UserController>()
          .setAuthenticatedUser(userId: currentUserId);
      // Store friends in local.
      List<String> friendIds =
          Get.find<UserController>().user.value!.friends ?? [];
      for (String id in friendIds) {
        User friend = await Get.find<UserController>().fetchUser(userId: id);
        friends.add(friend);
      }
      // Fetch both incoming and outgoing friend requests.
      QuerySnapshot incomingRequestsSnapshot = await firestore
          .collection(FirestoreCollections.friendRequests)
          .where("recipientId", isEqualTo: currentUserId)
          .get();
      QuerySnapshot outgoingRequestsSnapshot = await firestore
          .collection(FirestoreCollections.friendRequests)
          .where("senderId", isEqualTo: currentUserId)
          .get();
      // Combine both incoming and outgoing friend requests.
      for (var doc in incomingRequestsSnapshot.docs) {
        friendRequestsIn.add(FriendRequest.fromFirestore(doc));
      }
      for (var doc in outgoingRequestsSnapshot.docs) {
        friendRequestsOut.add(FriendRequest.fromFirestore(doc));
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> sendFriendRequest(
      {required String senderId,
      required String senderUsername,
      required String recipientId,
      required String recipientUsername}) async {
    try {
      // Create friendRequest model.
      FriendRequest friendRequest = FriendRequest(
          id: senderId + recipientId,
          senderId: senderId,
          senderUsername: senderUsername,
          recipientId: recipientId,
          recipientUsername: recipientUsername);
      // Save friendRequest to Firestore.
      await firestore
          .collection(FirestoreCollections.friendRequests)
          .doc(friendRequest.id)
          .set(friendRequest.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> acceptFriendRequest({
    required String senderId,
    required String recipientId,
  }) async {
    try {
      // Add sender to recipient's friend list.
      await updateUserFriendList(userId: recipientId, friendId: senderId);
      // Add recipient to sender's friend list.
      await updateUserFriendList(userId: senderId, friendId: recipientId);
      // Create chatGroup.
      await Get.find<ChatGroupController>()
          .createChatGroup(members: [senderId, recipientId], image: "");
      // Delete the friend request document.
      await deleteFriendRequest(senderId: senderId, recipientId: recipientId);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> deleteFriendRequest({
    required String senderId,
    required String recipientId,
  }) async {
    try {
      // Remove friendRequest from Firestore.
      await firestore
          .collection(FirestoreCollections.friendRequests)
          .doc(senderId + recipientId)
          .delete();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> buttonAction(
      {required String userId, required String buttonText}) async {
    String currentUserId = Get.find<UserController>().user.value!.id;
    switch (buttonText) {
      case "İsteği Sil":
        await deleteFriendRequest(senderId: currentUserId, recipientId: userId);
        break;
      case "Kabul Et":
        await acceptFriendRequest(senderId: userId, recipientId: currentUserId);
        break;
      case "Kaldır":
        await updateUserFriendList(
            userId: currentUserId, friendId: userId, isAdding: false);
        await updateUserFriendList(
            userId: userId, friendId: currentUserId, isAdding: false);
        break;
      case "Arkadaş Ekle":
        String recipientUsername = await Get.find<UserController>()
            .fetchUser(userId: userId)
            .then((value) => value.username);
        await sendFriendRequest(
            senderId: currentUserId,
            senderUsername: Get.find<UserController>().user.value!.username,
            recipientId: userId,
            recipientUsername: recipientUsername);
        break;
      default:
    }
    await fetchFriendRequests();
  }

  // Method to update users friends list.
  Future<void> updateUserFriendList(
      {required String userId,
      required String friendId,
      bool isAdding = true}) async {
    try {
      // Save to firestore.
      await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        "friends": isAdding
            ? FieldValue.arrayUnion([friendId])
            : FieldValue.arrayRemove([friendId])
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
