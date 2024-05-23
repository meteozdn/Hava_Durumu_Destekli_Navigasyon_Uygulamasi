import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/views/auth/login_screen.dart';
import 'package:navigationapp/views/auth/register_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final RxBool isLoginPage = true.obs;

  void toggleScreens() {
    isLoginPage.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return isLoginPage.value
          ? LoginScreen(showRegisterPage: toggleScreens)
          : RegisterScreen(showLoginPage: toggleScreens);
    });
  }
}
