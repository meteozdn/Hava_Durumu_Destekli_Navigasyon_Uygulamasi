import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/controllers/chat_group_controller.dart';
import 'package:navigationapp/controllers/create_route_controller.dart';
import 'package:navigationapp/controllers/friend_request_controller.dart';
import 'package:navigationapp/controllers/location_controller.dart';
import 'package:navigationapp/controllers/map_controller.dart';
import 'package:navigationapp/controllers/route_controller.dart';
import 'package:navigationapp/controllers/user_controller.dart';
import 'package:navigationapp/views/auth/auth_screen.dart';
import 'package:navigationapp/views/home/home_screen.dart';

import '../../core/constants/app_constants.dart';

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
    // Initialize controllers in order.
    await Get.putAsync<MapController>(() async => MapController());
    await Get.putAsync<LocationController>(() async => LocationController());

    await Get.putAsync<UserController>(() async => UserController(userId));
    await Get.find<UserController>().setAuthenticatedUser();

    await Get.putAsync<ChatGroupController>(() async => ChatGroupController());
    await Get.find<ChatGroupController>().fetchUserChatGroups();

    await Get.putAsync<RouteController>(() async => RouteController());
    await Get.find<RouteController>().fetchUserRoutes();

    Get.put(FriendRequestController());
    Get.put(CreateRouteController());
    Get.find<FriendRequestController>().fetchUserFriends();
  }

  Widget _buildLoadingScreen() {
    return Center(
        child: Lottie.asset(
      // options: LottieOptions(enableMergePaths: true),
      onWarning: (p0) {
        print(p0);
      },
      Animations.ld1,
    ));
  }
}
