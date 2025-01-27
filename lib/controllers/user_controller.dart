import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/friend_request_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/models/user.dart';

class UserController extends GetxController {
  UserController(this.currentUserId);

  final String currentUserId;
  Rx<User?> user = Rx<User?>(null);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? userSubscription;
  DocumentReference? userDocRef;

  @override
  void onInit() async {
    super.onInit();
    userDocRef =
        _firestore.collection(FirestoreCollections.users).doc(currentUserId);
    listenToUserUpdates();
  }

  @override
  void onClose() {
    userSubscription?.cancel();
    super.onClose();
  }

  void listenToUserUpdates() {
    userSubscription = userDocRef?.snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        User newUserData = User.fromFirestore(snapshot);
        User? oldUserData = user.value;
        user.value = newUserData;
        if (oldUserData == null) {
          return;
        }
        // Check for updates to "chatGroups" field.
        if (!areListsEqual(oldUserData.chatGroups!, user.value!.chatGroups!)) {
          await Get.find<ChatGroupController>().fetchUserChatGroups();
        }
        // Check for updates to "routes" field.
        if (!areListsEqual(oldUserData.routes!, user.value!.routes!)) {
          await Get.find<RouteController>().fetchUserRoutes();
        }
        // Check for updates to "friends" field.
        if (!areListsEqual(oldUserData.friends!, user.value!.friends!)) {
          await Get.find<FriendRequestController>().fetchUserFriends();
        }
      }
    });
  }

  bool areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    List<String> sortedList1 = List.from(list1)..sort();
    List<String> sortedList2 = List.from(list2)..sort();
    for (int i = 0; i < sortedList1.length; i++) {
      if (sortedList1[i] != sortedList2[i]) {
        return false;
      }
    }
    return true;
  }

  // Method to set user data.
  Future<void> setAuthenticatedUser() async {
    try {
      DocumentSnapshot docSnapshot = await userDocRef!.get();
      if (docSnapshot.exists) {
        user.value = User.fromFirestore(docSnapshot);
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to fetch user data.
  Future<User> fetchUser({required String userId}) async {
    try {
      DocumentSnapshot snapshot = await _firestore
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

  // Method to search for users by username.
  Future<List<User>> searchUsersByUsername({required String search}) async {
    try {
      List<User> searchResults = [];
      QuerySnapshot querySnapshot = await _firestore
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

  Future<void> updateProfilePhoto(
      {required String image, required String uid}) async {
    try {
      _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update(({"image": image}));
    } catch (e) {}
  }
}
