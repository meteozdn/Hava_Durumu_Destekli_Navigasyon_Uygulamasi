import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static const String appName = 'Navi App';
  static String baseURL = 'https://kindergardenapp.com:8000';
  static const String fontFamily = 'Roboto';
  static const String defaultLanguage = 'tr';
  // static const int responseTimeout = 60;
  // static int? userType;
}

class AppTextStyle {
  static final midBlack = TextStyle(fontSize: 20.sp, color: Colors.black);
}

class ColorConstants {
  /*static const Color pinkColor = Color(0xFFE24E74);
  static const Color greyColor = Color(0xFFD9D9D9);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF2C3333);
  static const Color greenColor = Color(0xFF8EC148);
  static const Color redColor = Color(0xFFD94555);
  static const Color purpleColor = Color(0xFF7C5DA4);
  static const Color blackPurpleColor = Color(0xFF3D2E6B);
  static const Color orangeColor = Color(0xFFFF9255);
  static const Color likedColor = Color(0xFFFFC830);
  static const Color leftPlateColor = Color(0xFFF8BA43);
  static const Color lightPinkColor = Color(0xFFFFEBFF);
  static const Color pictionBlueColor = Color(0xFF61B9ED);*/
  static const Color cardinalColor = Color(0xFFBD1742);
  static const Color lightBlue = Color(0xFFE0EEFD);
  static const Color pastelMagentaColor = Color(0xFFBD1742);
  static const Color blackColor = Color(0xFF2C3333);
  static const Color pictionBlueColor = Color(0xFF61B9ED);
  static const Color redColor = Color(0xFFD94555);
  static const Color pinkColor = Color(0xFFE24E74);
  static const Color greyColor = Color(0xFFD9D9D9);
  static const Color whiteColor = Color(0xFFFFFFFF);
}

class WeatherIcons {
  static const sunny = "lib/assets/icons/sunny.png";
  static const sunny2d = "lib/assets/icons/sunny2d.png";
  static const rainy2d = "lib/assets/icons/rainy2d.png";
  static const rainy = "lib/assets/icons/rainy.png";
  static const snow = "lib/assets/icons/snow.png";
  static const snow2d = "lib/assets/icons/snow2d.png";
  static const thunder = "lib/assets/icons/thunder.png";
  static const thunder2d = "lib/assets/icons/thunder2d.png";
}

class Animations {
  static const safeCar = "lib/assets/animations/safeCar.json";
  static const journeyCar = "lib/assets/animations/journeyCar.json";
  static const a = "lib/assets/animations/a.json";
  // static const safeCar = "lib/assets/animations/safeCar.json";
}

class IconConsts {
  static const line = "lib/assets/icons/line.png";
}

class IconsConst {
  static const blackNavigateIcon = "lib/assets/icons/navigate.png";
}
