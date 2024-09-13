// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF061C01),
    primary: Colors.black,
    secondary: Colors.black,
      inversePrimary: Color(0xFF8bc9b1),
    surface: Colors.black
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // Dark theme border color
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
);