import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:navigationapp/controllers/theme_change_controller.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/core/init/navigation/navigation_service.dart';
import 'package:navigationapp/firebase_options.dart';
import 'package:navigationapp/views/main/main_screen.dart';

Future<void> main() async {
  var date = DateTime.now().obs;
  await initializeDateFormatting("tr_TR", null).then((_) {
    final format = DateFormat('yyyy-MM-dd HH:mm', "tr_TR");
    date.value = format.parse(date.value.toString().substring(0, 16));
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final ThemeChanger themeChanger = Get.put(ThemeChanger());

//Theme Yönetimi
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final themeChanger = ThemeChanger.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
        stream: themeChanger.themeStream,
        initialData: themeChanger.defaultTheme(), // Varsayılan tema
        builder: (context, snapshot) {
          return ScreenUtilInit(
            designSize: const Size(400, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            // Use builder only if you need to use library outside ScreenUtilInit context
            builder: (_, child) {
              return GetMaterialApp(
                theme: snapshot.data, // Stream'den gelen temayı uygula

                getPages: NavigationService.routes,
                initialRoute: NavigationConstants.main,
                debugShowCheckedModeBanner: false,
                //     title: 'First Method',
                // You can use the library anywhere in the app even in theme

                // home: child,
              );
            },
            child: const MainScreen(),
          );
        });
  }
}
