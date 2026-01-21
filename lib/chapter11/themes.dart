import 'package:flutter/material.dart';

/// Chapter11: Persisting Data
///
enum AppThemes { light, dark }
//Themes definitions
ThemeData get defaultTheme => ThemeData(
      // Define the default brightness and colors for the overall app.
     useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
    secondary: Colors.lightBlueAccent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(
      color: Colors.white,
        ),
      ),
    );

ThemeData get pinkTheme => ThemeData(
      // Define the default brightness and colors for the overall app.
     useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
    secondary: Colors.pinkAccent,)
    );

ThemeData get darkTheme => ThemeData(
      // Define the default brightness and colors for the overall app.
       useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    brightness: Brightness.dark,
    secondary: Colors.yellowAccent,)
    );
