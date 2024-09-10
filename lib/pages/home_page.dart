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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _incompleteBannerUrls = [];
  List<String> _recentCompleteBannerUrls = [];

  int activeIndex = 0;
  final List<String> imageSliderImages = [
    'https://firebasestorage.googleapis.com/v0/b/android-club-65a70.appspot.com/o/Event%20Banners%2F2024%20Events%2FAndro%20Mania.jpg?alt=media&token=f3e3e966-e266-44e9-92f7-f52cc6f129db',
    'https://firebasestorage.googleapis.com/v0/b/android-club-65a70.appspot.com/o/Event%20Banners%2F2024%20Events%2FAndroidFusion.jpg?alt=media&token=a3c792ed-2ad4-45b8-8836-a71a3fe32f5a',
    'https://firebasestorage.googleapis.com/v0/b/android-club-65a70.appspot.com/o/Event%20Banners%2F2024%20Events%2FDSA_Tussle.jpg?alt=media&token=90d3eaad-26b5-4652-bac4-dfde0e841853'
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

    _fetchEventBanners();
  }

  Future<void> _fetchEventBanners() async {
    try {
      // Fetch events where completion is false
      QuerySnapshot incompleteSnapshot = await _firestore.collection('events')
          .where('completion', isEqualTo: false)
          .get();

      List<String> incompleteUrls = incompleteSnapshot.docs.map((doc) {
        return doc['bannerURL'] as String;
      }).toList();

      // Fetch the five most recent events where completion is true
      QuerySnapshot recentCompleteSnapshot = await _firestore.collection('events')
          .where('completion', isEqualTo: true)
          // .orderBy('date', descending: true)
          .limit(5)
          .get();

      List<String> recentCompleteUrls = recentCompleteSnapshot.docs.map((doc) {
        return doc['bannerURL'] as String;
      }).toList();

      // Update state with fetched banner URLs
      setState(() {
        _incompleteBannerUrls = incompleteUrls;
        _recentCompleteBannerUrls = recentCompleteUrls;
      });
    } catch (e) {
      print('Error fetching banner URLs: $e');
    }
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
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                : SafeArea(
                    child: Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [

                                SizedBox(height: 18,),

                                // Current/Upcoming Events

                                if (_incompleteBannerUrls.isNotEmpty) ...[
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

                                  SizedBox(height: 10,),

                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: CarouselSlider.builder(
                                      itemCount: _incompleteBannerUrls.length,
                                      itemBuilder: (context, index, realIndex) {
                                        final urlimage = _incompleteBannerUrls[index];
                                        return buildImage(urlimage, index);
                                      },
                                      options: CarouselOptions(
                                        height: 300,
                                        aspectRatio: 1 / 1,
                                        enlargeCenterPage: true,
                                        viewportFraction: 0.8,
                                        autoPlay: true,
                                        autoPlayInterval: Duration(seconds: 5),
                                          enableInfiniteScroll: _incompleteBannerUrls.length > 1
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                ],

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

                                SizedBox(height: 10,),

                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: CarouselSlider.builder(
                                    itemCount: _recentCompleteBannerUrls.length,
                                    itemBuilder: (context, index, realIndex) {
                                      final urlimage = _recentCompleteBannerUrls[index];
                                      return buildImage(urlimage, index);
                                    },
                                    options: CarouselOptions(
                                      height: 350,
                                      aspectRatio: 1 / 1,
                                      initialPage: 3,
                                      enlargeCenterPage: true,
                                      viewportFraction: 0.8,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 4),
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

  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
