import 'dart:async';
import 'package:flutter/material.dart';

class ThemeChanger {
  static final ThemeChanger _instance = ThemeChanger._internal();

  factory ThemeChanger() {
    return _instance;
  }

  ThemeChanger._internal();

  static ThemeChanger get instance => _instance;

  final _themeController = StreamController<ThemeData>.broadcast();

  Stream<ThemeData> get themeStream => _themeController.stream;

  setTheme(ThemeData theme) {
    _themeController.sink.add(theme);
  }

  dispose() {
    _themeController.close();
  }

  // Tema tanımlayıcı metodlar
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
