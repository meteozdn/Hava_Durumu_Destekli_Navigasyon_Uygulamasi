import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigationapp/core/controllers/chat_group_controller.dart';
import 'package:navigationapp/core/controllers/friend_request_controller.dart';
import 'package:navigationapp/core/controllers/route_controller.dart';
import 'package:navigationapp/core/controllers/user_controller.dart';
import 'package:navigationapp/core/models/user.dart' as model;

class AuthController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

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
      );
      // Access the UserController instance.;
      Get.find<UserController>().createUser(user: user);
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
    Get.delete<UserController>();
    Get.delete<ChatGroupController>();
    Get.delete<FriendRequestController>();
    Get.delete<RouteController>();
  }
}
