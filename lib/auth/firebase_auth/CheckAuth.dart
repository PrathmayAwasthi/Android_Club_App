import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/pages/user_info_page.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:android_club_app/auth/firebase_auth//login_page.dart';


class CheckAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return BottomNav();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
