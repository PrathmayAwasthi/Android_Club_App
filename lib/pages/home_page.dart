// ignore_for_file: prefer_const_constructors

import 'package:android_club_app/pages/user_info_page.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_club_app/auth/firebase_auth/userDetDialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String? _errorMessage;

  int activeIndex = 0;
  final imageSliderImages = [
    'https://instagram.fidr4-3.fna.fbcdn.net/v/t51.29350-15/441694487_1125226148806078_5259781858375431588_n.heic?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xMDgweDEwODAuc2RyLmYyOTM1MCJ9&_nc_ht=instagram.fidr4-3.fna.fbcdn.net&_nc_cat=110&_nc_ohc=IdCAxM-DHekQ7kNvgEqT7y4&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzM2Mjg5OTAwOTk1MzUyMzc0Nw%3D%3D.2-ccb7-5&oh=00_AYAsn46Nh5f2gZnsdYgwg6XCxuc5VbjG_ratpNjx0d07HA&oe=66B963B4&_nc_sid=8f1549',
    'https://instagram.fidr4-3.fna.fbcdn.net/v/t51.29350-15/427927525_187351874472305_4775189296717571015_n.heic?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xMDgweDEwODAuc2RyLmYyOTM1MCJ9&_nc_ht=instagram.fidr4-3.fna.fbcdn.net&_nc_cat=105&_nc_ohc=fIHs_sRGOTkQ7kNvgHT6l7A&edm=AFg4Q8wBAAAA&ccb=7-5&ig_cache_key=MzMwNDExMzcyNTQ3ODQwNjIyOA%3D%3D.2-ccb7-5&oh=00_AYB5Ap9HS2MB3QS476699PEiu3fLfnJqq4mt4Zxg7_u9wg&oe=66B9605C&_nc_sid=0b30b7',
    'https://instagram.fidr4-2.fna.fbcdn.net/v/t51.29350-15/345668615_571788108398666_5628123569132887542_n.heic?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xMDgweDEwODAuc2RyLmYyOTM1MCJ9&_nc_ht=instagram.fidr4-2.fna.fbcdn.net&_nc_cat=102&_nc_ohc=496J1m8ziN8Q7kNvgFd6kMG&edm=AFg4Q8wBAAAA&ccb=7-5&ig_cache_key=MzA5OTYwNzg1Nzk1ODU2ODM5NA%3D%3D.2-ccb7-5&oh=00_AYBoSJ9j3k-BZmCQiXIP1D_YsQtXYuEee6I4xAJfmz_WGQ&oe=66B96BCD&_nc_sid=0b30b7'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(user.uid);
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
      body: Container(
        child: _isLoading
            ? CircularProgressIndicator()
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                : SafeArea(
                    child: Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                            
                                SizedBox(height: 18,),
                            
                                // Current/Upcoming Events
                            
                                Container(
                                  child: Text(
                                    "UPCOMING EVENTS",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 5,
                                    ),
                                    
                                  ),
                                ),
                            
                                SizedBox(height: 24,),
                            
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CarouselSlider.builder(
                                    itemCount: imageSliderImages.length,
                                    itemBuilder: (context, index, realIndex) {
                                      final urlimage = imageSliderImages[index];
                                      return buildImage(urlimage, index);
                                    },
                                    options: CarouselOptions(
                                      height: 350,
                                      aspectRatio: 1 / 1,
                                      enlargeCenterPage: true,
                                      viewportFraction: 0.7,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                            
                                // Past Events
                            
                                SizedBox(height: 24,),
                            
                                Container(
                                  child: Text(
                                    "RECENT EVENTS",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 5,
                                    ),
                                    
                                  ),
                                ),
                          
                                SizedBox(height: 24,),
                            
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CarouselSlider.builder(
                                    itemCount: imageSliderImages.length,
                                    itemBuilder: (context, index, realIndex) {
                                      final urlimage = imageSliderImages[index];
                                      return buildImage(urlimage, index);
                                    },
                                    options: CarouselOptions(
                                      height: 350,
                                      aspectRatio: 1 / 1,
                                      initialPage: 2,
                                      enlargeCenterPage: true,
                                      viewportFraction: 0.7,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 2),
                                    ),
                                  ),
                                ),
                            
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget buildImage(String urlimage, int index) => Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Image.network(
        urlimage,
        fit: BoxFit.cover,
      ));
}
