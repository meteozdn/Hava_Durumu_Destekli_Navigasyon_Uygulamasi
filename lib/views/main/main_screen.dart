import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/core/controllers/auth_controller.dart';
import 'package:navigationapp/core/controllers/chat_group_controller.dart';
import 'package:navigationapp/core/controllers/friend_request_controller.dart';
import 'package:navigationapp/core/controllers/route_controller.dart';
import 'package:navigationapp/core/controllers/user_controller.dart';
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
            Get.find<UserController>()
                .setUser(userId: authController.user.value!.uid);
            Get.put(FriendRequestController());
            Get.put(ChatGroupController());
            Get.put(RouteController());
            return HomeScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
