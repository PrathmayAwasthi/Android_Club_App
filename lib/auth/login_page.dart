// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:android_club_app/auth/signup_page.dart';
import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                size: 75.0,
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
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav()))
                },
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
              SizedBox(height: 15.0),

              // Other Login Methods Text
              Text("Or Continue With"),

              // Spacing
              SizedBox(height: 15.0),

              // Other login methods icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('assets/images/github_logo.png'),
                    size: 50,
                  ),
                  SizedBox(width: 10,),
                  ImageIcon(
                    AssetImage('assets/images/gmail_logo.png'),
                    size: 50,
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
                        MaterialPageRoute(builder: (context) => const SignupPage())
                      )
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
}
