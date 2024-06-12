import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/friend_request_controller.dart';
import 'package:navigationapp/controllers/journey_controller.dart';
import 'package:navigationapp/controllers/navigation_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/views/auth/auth_screen.dart';
import 'package:navigationapp/views/home/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AuthController>(
        init: AuthController(),
        builder: (authController) {
          if (authController.user.value != null) {
            return _buildAuthenticatedScreens(authController);
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }

  Widget _buildAuthenticatedScreens(AuthController authController) {
    return FutureBuilder<void>(
      future: _initializeUserController(authController.user.value!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else {
          return HomeScreen();
        }
      },
    );
  }

  Future<void> _initializeUserController(String userId) async {
    // Initialize UserController first.
    await Get.putAsync<UserController>(() async => UserController(userId));
    final userC = Get.find<UserController>();
    await userC.setAuthenticatedUser();

    // Then initialize ChatGroupController.
    await Get.putAsync<ChatGroupController>(() async => ChatGroupController());
    final chatGroupC = Get.find<ChatGroupController>();
    await chatGroupC.fetchUserChatGroups();

    // Then initialize RouteController.
    await Get.putAsync<RouteController>(() async => RouteController());
    final routeC = Get.find<RouteController>();
    await routeC.fetchUserRoutes();

    // Then initialize other controllers.
    Get.put(FriendRequestController());
    await Get.find<FriendRequestController>().fetchUserFriends();
    // await Get.putAsync<FriendRequestController>(
    //     () async => FriendRequestController());
    await Get.putAsync<NavigationController>(
        () async => NavigationController());
    await Get.putAsync<JourneyController>(() async => JourneyController());
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
