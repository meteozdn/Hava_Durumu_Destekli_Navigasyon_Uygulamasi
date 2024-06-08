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
          Get.put(UserController());
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
      future: _initializeControllers(authController.user.value!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else {
          return HomeScreen();
        }
      },
    );
  }

  Future<void> _initializeControllers(String userId) async {
    final userController = Get.find<UserController>();
    await userController.setAuthenticatedUser(userId: userId);

    Future chatGroupControllerFuture = Future(() {
      Get.put(ChatGroupController());
    });
    await Future.wait([chatGroupControllerFuture]);
    Get.put(RouteController());
    Get.put(FriendRequestController());
    Get.put(NavigationController());
    Get.put(JourneyController());
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
