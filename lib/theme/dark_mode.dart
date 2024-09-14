// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF121212),
    primary: Color(0xFF282828),
    secondary: Color(0xFF282828),
    inversePrimary: Color(0xFF999999),
    surface: Color(0xFF282828),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.openSans(
      fontSize: 16,
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

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF121212), // background color of the button
      foregroundColor: Colors.white, // text color of the button
      elevation: 2, // elevation of the button
      textStyle: GoogleFonts.poppins(),
    ),
  ),

  cardTheme: CardTheme(
    // color: Colors.black, // background color for the card
    elevation: 4, // card elevation to cast shadow
    // shadowColor: Colors.white, // white shadow for the card
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // rounded corners for the card
    ),
  ),

);