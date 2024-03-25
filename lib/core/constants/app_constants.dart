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
  static TextStyle get baseStyle => TextStyle(
        fontSize: 14.sp,
        fontFamily: "RobotoRegular",
        color: ColorConstants.pinkColor,
      );
  static TextStyle get boldStyle =>
      baseStyle.copyWith(fontFamily: "RobotoBold");
  static TextStyle get mediumStyle =>
      baseStyle.copyWith(fontFamily: "RobotoMedium");
  static TextStyle get lightStyle =>
      baseStyle.copyWith(fontFamily: "RobotoLight");
}

class ColorConstants {
  static const Color pinkColor = Color(0xFFE24E74);
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
  static const Color blueColor = Color(0xFF7d97f4);
  static const Color pastelMagentaColor = Color(0xFFF18DBF);
  static const Color cardinalColor = Color(0xFFBD1742);
}
