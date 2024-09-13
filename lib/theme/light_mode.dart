// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xffE0EDE3),
    primary: Colors.white,
    secondary: Colors.white,
    inversePrimary: Color(0xFFA2DDC6),
  ),


  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black), // Dark theme border color
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  ),

);