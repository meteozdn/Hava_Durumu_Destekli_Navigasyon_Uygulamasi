import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:navigationapp/core/constants/app_constants.dart';
import 'package:navigationapp/core/constants/navigation_constants.dart';
import 'package:navigationapp/core/init/navigation/navigation_service.dart';
import 'package:navigationapp/firebase_options.dart';
import 'package:navigationapp/views/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controllers/theme_changer_controller.dart';

Future<void> main() async {
  var date = DateTime.now().obs;
  await initializeDateFormatting("tr_TR", null).then((_) {
    final format = DateFormat('yyyy-MM-dd HH:mm', "tr_TR");
    date.value = format.parse(date.value.toString().substring(0, 16));
    print(date.value.toString());
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ThemeChanger sınıfını kullanarak tema değişikliklerini yönetin
  final themeChanger = ThemeChanger.instance;

  runApp(
    // ThemeChanger Stream'ini dinleyen bir StreamBuilder kullanın
    StreamBuilder<ThemeData>(
      stream: themeChanger.themeStream,
      initialData: ThemeData.light(), // Varsayılan tema
      builder: (context, snapshot) {
        return ScreenUtilInit(
          designSize: const Size(400, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return GetMaterialApp(
              getPages: NavigationService.routes,
              initialRoute: NavigationConstants.main,
              debugShowCheckedModeBanner: false,
              theme: snapshot.data, // Stream'den gelen temayı uygula
              // Diğer MaterialApp ayarları...
              home: const MainScreen(),
            );
          },
        );
      },
    ),
  );
}
