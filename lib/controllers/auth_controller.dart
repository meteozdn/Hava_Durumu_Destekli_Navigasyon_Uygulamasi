import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigationapp/controllers/chat_controller.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/friend_request_controller.dart';
import 'package:navigationapp/controllers/journey_controller.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/core/constants/firestore_collections.dart';
import 'package:navigationapp/models/user.dart' as model;

class AuthController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Listen to authentication changes.
    user.bindStream(getAuth().authStateChanges());
  }

  FirebaseAuth getAuth() {
    return FirebaseAuth.instance;
  }

  String getAuthId() {
    try {
      return user.value!.uid;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String name,
    required String surname,
  }) async {
    try {
      // Create user to Authentication.
      UserCredential credential = await getAuth()
          .createUserWithEmailAndPassword(email: email, password: password);
      // Create user to Firestore.
      model.User user = model.User(
          id: credential.user!.uid,
          username: username,
          name: name,
          surname: surname,
          registerAt: DateTime.now(),
          image: "");
      await createUser(user: user);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Method to create a new user.
  Future<void> createUser({required model.User user}) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.id)
          .set(user.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await getAuth()
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> logout() async {
    await getAuth().signOut();
    ChatGroupController chatGroupController = Get.find<ChatGroupController>();
    for (var chatGroup in chatGroupController.chatGroups) {
      Get.delete<ChatController>(tag: chatGroup.id, force: true);
    }
    Get.delete<UserController>();
    Get.delete<ChatGroupController>();
    Get.delete<FriendRequestController>();
    Get.delete<RouteController>();
    Get.delete<JourneyController>();
    Get.delete<LocationController>();
    Get.delete<MapController>();
    Get.back();
  }
}
