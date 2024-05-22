import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/views/home/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          //     title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: ColorConstants.pictionBlueColor),
            textTheme: Typography.englishLike2018.apply(
              bodyColor: ColorConstants.blackColor,
              fontSizeFactor: 1.sp,
            ),
          ),
          home: child,
        );
      },
      child: HomeScreen(),
    );
  }
}
