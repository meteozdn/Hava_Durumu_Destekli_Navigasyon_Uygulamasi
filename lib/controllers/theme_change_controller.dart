import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navigationapp/core/constants/app_constants.dart';

class ThemeChanger {
  static final ThemeChanger _instance = ThemeChanger._internal();

  factory ThemeChanger() {
    return _instance;
  }

  ThemeChanger._internal();

  static ThemeChanger get instance => _instance;
  final ThemeData initTheme = ThemeData(
      appBarTheme:
          const AppBarTheme(color: ColorConstants.lightGrey), // AppBar rengi
      scaffoldBackgroundColor: ColorConstants.lightGrey, // Arka plan rengi
      primaryColor: ColorConstants.whiteColor, // Birincil renk

      hintColor: ColorConstants.pictionBlueColor, // Vurgu rengi
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorConstants.pictionBlueColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  ColorConstants.pictionBlueColor)))

      // Diğer tema özellikleri buraya eklenebilir
      );

  final _themeController = StreamController<ThemeData>.broadcast();

  Stream<ThemeData> get themeStream => _themeController.stream;

  setTheme(ThemeData theme) {
    _themeController.sink.add(theme);
  }

  dispose() {
    _themeController.close();
  }

  // Tema tanımlayıcı metodlar

  ThemeData defaultTheme() {
    return ThemeData(
        appBarTheme:
            const AppBarTheme(color: ColorConstants.lightGrey), // AppBar rengi
        scaffoldBackgroundColor: ColorConstants.lightGrey, // Arka plan rengi
        primaryColor: ColorConstants.whiteColor, // Birincil renk

        hintColor: ColorConstants.pictionBlueColor, // Vurgu rengi
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: ColorConstants.pictionBlueColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    ColorConstants.pictionBlueColor)))

        // Diğer tema özellikleri buraya eklenebilir
        );
  }

  ThemeData buildOrangeTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(color: Colors.orange), // AppBar rengi
      scaffoldBackgroundColor: Colors.orange, // Arka plan rengi
      primaryColor: Colors.orange, // Birincil renk
      hintColor: Colors.orangeAccent, // Vurgu rengi
      // Diğer tema özellikleri buraya eklenebilir
    );
  }

  ThemeData buildRedTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(color: Colors.red), // AppBar rengi
      scaffoldBackgroundColor: Colors.red, // Arka plan rengi
      primaryColor: Colors.red, // Birincil renk
      hintColor: Colors.red, // Vurgu rengi
      // Diğer tema özellikleri buraya eklenebilir
    );
  }

  ThemeData buildBlueTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(color: Colors.blue), // AppBar rengi
      scaffoldBackgroundColor: Colors.blue, // Arka plan rengi
      primaryColor: Colors.blue, // Birincil renk
      hintColor: Colors.blue, // Vurgu rengi
      // Diğer tema özellikleri buraya eklenebilir
    );
  }

  ThemeData buildPinkTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(color: Colors.pink), // AppBar rengi
      scaffoldBackgroundColor: Colors.pink, // Arka plan rengi
      primaryColor: Colors.pink, // Birincil renk
      hintColor: Colors.pinkAccent,

      // Diğer tema özellikleri buraya eklenebilir
    );
  }
}
