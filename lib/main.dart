import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/core/init/navigation/navigation_service.dart';
import 'package:navigationapp/firebase_options.dart';
import 'package:navigationapp/views/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        return GetMaterialApp(
          getPages: NavigationService.routes,
          initialRoute: NavigationConstants.home,
          debugShowCheckedModeBanner: false,
          //     title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: ColorConstants.whiteColor),
            scaffoldBackgroundColor: ColorConstants.whiteColor,
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
