 // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:android_club_app/auth/firebase_auth/firebase_auth_implement.dart';
import 'package:android_club_app/auth/firebase_auth//login_page.dart';
import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    super.key,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final FirebaseAuthImplement auth = FirebaseAuthImplement();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.android,
                size: 75.0,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              // spacing between
              SizedBox(height: 10.0),

              // Intro Text
              Text("Welcome to Android Club!"),

              // spacing between
              SizedBox(height: 20.0),

              // Email TextField
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Name",
                ),
              ),

              // spacing between
              SizedBox(height: 20.0),

              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "E-mail",
                ),
              ),

              // spacing between
              SizedBox(height: 20.0),

              // Password TextField
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Password",
                ),
                obscureText: true,
              ),

              // spacing between
              SizedBox(height: 20.0),

              // Password TextField
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Confirm Password",
                ),
                obscureText: true,
              ),

              // Spacing
              SizedBox(height: 20.0),

              // Log In Button
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  width: 110,
                  height: 45,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 18.0),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ),

              // Spacing
              SizedBox(height: 15.0),

              // Other Login Methods Text
              Text("Or Continue With"),

              // Spacing
              SizedBox(height: 5.0),

              // Other login methods icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: signInWithGoogle,
                    child: ImageIcon(
                      AssetImage('assets/images/gmail_logo.png'),
                      size: 50,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: signInWithGitHub,
                    child: ImageIcon(
                      AssetImage('assets/images/github_logo.png'),
                      size: 50,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),

              // Spacing
              SizedBox(height: 15.0),

              // Register Now redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pop(context)
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password!= confirmPassword) {
      print("Passwords do not match");
      return;
    }

    User? user = await auth.signUpWithEmailAndPassword(email, password);
    if (user!= null) {
      print("User Created");
      // You can also navigate to the home page or perform other actions here
    } else {
      print("Error creating user");
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        print("Google sign-in successful");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<UserCredential> signInWithGitHub() async {
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      final UserCredential result = await _firebaseAuth.signInWithProvider(githubProvider);
      final User? user = result.user;
      if (user != null) {
        print("GitHub login successful: ${user.uid}");
        return result;
      } else {
        throw FirebaseAuthException(code: 'ERROR', message: 'GitHub sign-in failed');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
