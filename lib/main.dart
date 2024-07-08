import 'package:android_club_app/theme/light_mode.dart';
import 'package:android_club_app/theme/dark_mode.dart';
import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_auth/CheckAuth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}