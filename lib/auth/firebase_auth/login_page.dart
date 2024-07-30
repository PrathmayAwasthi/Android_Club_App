// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:android_club_app/auth/firebase_auth/firebase_auth_implement.dart';
import 'package:android_club_app/auth/firebase_auth/signup_page.dart';
import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthImplement auth = FirebaseAuthImplement();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void redirectToForgotPassword() {}

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
                size: 90.0,
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

              // Spacing
              SizedBox(
                height: 15.0,
              ),

              // Forgot Password Text
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: redirectToForgotPassword,
                    child: Text("Forgot Password?"),
                  ),
                ],
              ),

              // Spacing
              SizedBox(height: 15.0),

              // Log In Button
              GestureDetector(
                onTap: login,
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
                        "Log In",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ),

              // Spacing
              SizedBox(height: 55.0),

              // Other Login Methods Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FractionalTranslation(
                    translation: Offset(0, 0),
                    child: Container(
                        width: 90,
                        height: 1.5,
                        child: SizedBox(
                          height: 1,
                          width: 1,
                          child: ColoredBox(color: Theme.of(context).colorScheme.inversePrimary),
                        )),
                  ),
                  Text("   Or Continue With   "),
                  FractionalTranslation(
                    translation: Offset(0, 0),
                    child: Container(
                        width: 90,
                        height: 1.5,
                        child: SizedBox(
                          height: 1,
                          width: 1,
                          child: ColoredBox(color: Theme.of(context).colorScheme.inversePrimary),
                        )),
                  ),
                ],
              ),

              // Spacing
              SizedBox(height: 15.0),

              // Other login methods icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: signInWithGoogle,
                    child: ImageIcon(
                      AssetImage('assets/images/gmail_logo.png'),
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: signInWithGitHub,
                    child: ImageIcon(
                      AssetImage('assets/images/github_logo.png'),
                      size: 50,
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
                  Text("First time here? "),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()))
                    },
                    child: Text(
                      "Register now",
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

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      print("User Logged In");
    } else {
      print("Error logging in");
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        print("Google sign-in successful");
      }
    } catch (e) {
      print("Error Google Sign In: $e");
    }
  }

  Future<UserCredential> signInWithGitHub() async {
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      final UserCredential result =
          await _firebaseAuth.signInWithProvider(githubProvider);
      final User? user = result.user;
      if (user != null) {
        print("GitHub login successful: ${user.uid}");
        return result;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR', message: 'GitHub sign-in failed');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
