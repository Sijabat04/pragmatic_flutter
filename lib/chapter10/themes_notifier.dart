import 'package:flutter/material.dart';

// Switching themes using Provider
enum MyThemes { light, dark }

class ThemesNotifier with ChangeNotifier {
  // Updated theme definitions
  static final List<ThemeData> themeData = [
    ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        secondary: Colors.lightBlueAccent, // replaces accentColor
        brightness: Brightness.light,
      ),
    ),
    ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        secondary: Colors.yellowAccent, // replaces accentColor
        brightness: Brightness.dark,
      ),
    ),
  ];

  MyThemes _currentTheme = MyThemes.light;
  ThemeData _currentThemeData = themeData[0];

  void switchTheme() {
    currentTheme = (_currentTheme == MyThemes.light)
        ? MyThemes.dark
        : MyThemes.light;
  }

  set currentTheme(MyThemes theme) {
    _currentTheme = theme;
    _currentThemeData =
        theme == MyThemes.light ? themeData[0] : themeData[1];
    notifyListeners();
  }

  MyThemes get currentTheme => _currentTheme;
  ThemeData get currentThemeData => _currentThemeData;
}
