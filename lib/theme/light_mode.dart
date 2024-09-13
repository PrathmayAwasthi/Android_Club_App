// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xffcae8c3),
    primary: Colors.white,
    secondary: Colors.white,
    inversePrimary: Color(0xFF8bc9b1),
    surface: Color(0xffe5f7e1)
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