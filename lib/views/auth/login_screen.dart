import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigationapp/controllers/auth_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class LoginScreen extends GetView<AuthController> {
  final VoidCallback showRegisterPage;

  const LoginScreen({super.key, required this.showRegisterPage});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      //backgroundColor: C,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100) +
                  const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Image.asset(
                      IconsConst.logo3,
                      width: 160,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: ColorConstants.pictionBlueColor,
                        border: Border.all(
                          width: 5,
                          color: ColorConstants.pictionBlueColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "e-posta",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 5,
                          color: ColorConstants.pictionBlueColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Şifre",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      controller.login(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: ColorConstants.pictionBlueColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: showRegisterPage,
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
