import 'package:android_club_app/auth/signup_page.dart';
import 'package:android_club_app/theme/light_mode.dart';
import 'package:android_club_app/theme/dark_mode.dart';
import 'package:flutter/material.dart';
import 'auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}