import 'package:flutter/material.dart';

var apptheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.grey[800],
    accentColor: Colors.orange[600],
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.orange[600],
      selectionColor: Colors.orange[600],
      selectionHandleColor: Colors.orange[600],
    ),
    hintColor: Colors.grey[800],
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
          fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
      headline4: TextStyle(
          fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 16.0, color: Colors.black),
      headline6: TextStyle(fontSize: 10.0, color: Colors.black),
      bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Serif'),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Serif'),
      button: TextStyle(fontSize: 22),
    ));
