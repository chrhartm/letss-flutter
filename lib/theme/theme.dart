import 'package:flutter/material.dart';

var apptheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      primary: Colors.grey[300]!,
      primaryContainer: Colors.orange[300]!, // should be darker
      onPrimary: Colors.black,
      secondary: Colors.grey,
      secondaryContainer: Colors.orange, // should be darker
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      background: Colors.white,
      onBackground: Colors.black,
      brightness: Brightness.light,
    ),
    // Sets bottomnavigationbar color
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      focusColor: Colors.orange[600],
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    ),

    // Define the default font family.
    fontFamily: "Roboto",

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32.0, color: Colors.black, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
          fontSize: 26.0, color: Colors.black, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 20.0, color: Colors.black),
      headlineMedium: TextStyle(
          fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 16.0, color: Colors.black),
      titleLarge: TextStyle(fontSize: 10.0, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 14.0, fontFamily: 'Serif'),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Serif'),
      labelLarge: TextStyle(fontSize: 18, color: Colors.white),
      labelMedium: TextStyle(fontSize: 16, color: Colors.grey),
    ));
