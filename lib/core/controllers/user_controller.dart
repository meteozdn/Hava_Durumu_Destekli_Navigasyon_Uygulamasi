import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/core/controllers/auth_controller.dart';
import 'package:navigationapp/core/models/user.dart';

class UserController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  var friends = <User>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Method to set user data.
  Future<void> setUser({required String userId}) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();
      // Create instance of user.
      User user = User.fromFirestore(snapshot);
      this.user.value = user;
      friends.value = await getFriendsList();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to fetch user data.
  Future<User> fetchUser({required String userId}) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();
      // Create instance of user.
      User user = User.fromFirestore(snapshot);
      return user;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to create a new user.
  Future<void> createUser({required User user}) async {
    try {
      await firestore
          .collection(FirestoreCollections.users)
          .doc(user.id)
          .set(user.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to search for users by username.
  Future<List<User>> searchUsersByUsername({required String search}) async {
    try {
      List<User> searchResults = [];
      QuerySnapshot querySnapshot = await firestore
          .collection(FirestoreCollections.users)
          .where("username", isGreaterThanOrEqualTo: search)
          .where("username", isLessThan: '${search}z')
          .get();
      for (var user in querySnapshot.docs) {
        if (user.id != Get.find<AuthController>().getAuthId()) {
          searchResults.add(User.fromFirestore(user));
        }
      }
      return searchResults;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to get users friends list.
  Future<List<User>> getFriendsList() async {
    try {
      User currentUser = user.value!;
      List<String> friendIds = currentUser.friends ?? [];
      List<User> friends = [];
      for (String id in friendIds) {
        DocumentSnapshot snapshot = await firestore
            .collection(FirestoreCollections.users)
            .doc(id)
            .get();
        User friend = User.fromFirestore(snapshot);
        friends.add(friend);
      }
      return friends;
    } catch (error) {
      throw Exception("Error updating friend list: $error");
    }
  }

  // Method to update users friends list.
  Future<void> updateUserFriendList(
      {required String userId,
      required String friendId,
      bool isAdding = true}) async {
    try {
      // Update user's friend list.
      List<String> friends = user.value!.friends ?? [];
      if (isAdding) {
        friends.add(friendId);
      } else {
        friends.remove(friendId);
      }
      // Update local user data.
      user.value!.friends = friends;
      this.friends.value = await getFriendsList();
      // Save to firestore.
      await firestore
          .collection(FirestoreCollections.users)
          .doc(user.value!.id)
          .update({"friends": friends});
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to update users chatGroup list.
  Future<void> updateUserChatGroupList({
    required String chatGroupId,
    required String userId,
    bool isAdding = true,
  }) async {
    try {
      // Update user's chatGroup list.
      List<String> chatGroups = user.value!.chatGroups ?? [];
      if (isAdding) {
        chatGroups.add(chatGroupId);
      } else {
        chatGroups.remove(chatGroupId);
      }
      // Update local user data.
      user.value!.chatGroups = chatGroups;
      // Save to firestore.
      await firestore
          .collection(FirestoreCollections.users)
          .doc(user.value!.id)
          .update({"chatGroups": chatGroups});
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to update users route list.
  Future<void> updateUserRouteList({
    required String routeId,
    bool isAdding = true,
  }) async {
    try {
      // Update user's route list.
      List<String> routes = user.value!.routes ?? [];
      if (isAdding) {
        routes.add(routeId);
      } else {
        routes.remove(routeId);
      }
      // Update local user data.
      user.value!.routes = routes;
      // Save to firestore.
      await firestore
          .collection(FirestoreCollections.users)
          .doc(user.value!.id)
          .update({"routes": routes});
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
