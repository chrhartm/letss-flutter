import 'package:flutter/material.dart';

var apptheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.grey[800],
    accentColor: Colors.orange[600],

    // Define the default font family.
    fontFamily: 'Roboto',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 72.0, color: Colors.black, fontWeight: FontWeight.bold),
        headline6: TextStyle(
            fontSize: 36.0, color: Colors.black, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        button: TextStyle(fontSize: 26)));
