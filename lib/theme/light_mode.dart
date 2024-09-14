// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xffcae8c3),
    primary: Colors.white,
    secondary: Colors.white,
    inversePrimary: Color(0xFF999999),
    surface: Color(0xffe5f7e1)
  ),


  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.openSans(
      fontSize: 16,
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

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xffcae8c3), // background color of the button
      foregroundColor: Colors.black, // text color of the button
      elevation: 2, // elevation of the button
      textStyle: GoogleFonts.poppins(),
    ),
  ),

  cardTheme: CardTheme(
    // color: Colors.black, // background color for the card
    elevation: 4, // card elevation to cast shadow
    shadowColor: Colors.black, // white shadow for the card
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // rounded corners for the card
    ),
  ),

);