import 'package:flutter/material.dart';

var apptheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      primary: Colors.black,
      primaryVariant: Colors.black, // should be darker
      onPrimary: Colors.white,
      secondary: Colors.orange,
      secondaryVariant: Colors.orangeAccent, // should be darker
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      background: Colors.white,
      onBackground: Colors.black,
      brightness: Brightness.light,
    ),
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
    fontFamily: 'Roboto',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      headline1: TextStyle(
          fontSize: 26.0, color: Colors.black, fontWeight: FontWeight.bold),
      headline2: TextStyle(
          fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
      headline3: TextStyle(
          fontSize: 20.0, color: Colors.black),
      headline4: TextStyle(
          fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 16.0, color: Colors.black),
      headline6: TextStyle(fontSize: 10.0, color: Colors.black),
      bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Serif'),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Serif'),
      button: TextStyle(fontSize: 22, color: Colors.white),
    ));
