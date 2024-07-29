// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 24, 62, 47),
    primary: Colors.white,
    secondary: Color.fromARGB(255, 49, 49, 49),
    inversePrimary: Color(0xFF4A9C7E),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),

);
