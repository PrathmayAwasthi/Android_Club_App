// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 22, 22, 22),
    primary: Colors.black,
    secondary: Color.fromARGB(255, 49, 49, 49),
    inversePrimary: Colors.white,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),

);
