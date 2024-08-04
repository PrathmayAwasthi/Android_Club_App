import 'package:android_club_app/pages/user_info_page.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_club_app/auth/firebase_auth/userDetDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
          final docSnapshot = await userDoc.get();

          if (docSnapshot.exists) {
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            showUserDetailsDialog(context, user);
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
            _errorMessage = "Error checking user data: $e";
          });
          print(_errorMessage);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
        ? CircularProgressIndicator()
        : _errorMessage != null
        ? Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(25.0),
          child: ElevatedButton(
            child: Text("User Info",style: Theme.of(context).textTheme.titleMedium,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserInfoPage()),
              );
            },
          ),
        ),

      ),
    );
  }
}
