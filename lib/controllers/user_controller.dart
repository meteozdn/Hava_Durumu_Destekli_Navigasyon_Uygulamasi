import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/models/user.dart';

class UserController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Rx<User?> user = Rx<User?>(null);

  // Method to set user data.
  Future<void> setAuthenticatedUser({required String userId}) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();
      // Create instance of user.
      User user = User.fromFirestore(snapshot);
      this.user.value = user;
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

  Future<void> updateProfilePhoto(
      {required String image, required String uid}) async {
    try {
      firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update(({"image": image}));
    } catch (e) {}
  }
}
