import 'package:android_club_app/pages/user_info_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class appBar extends StatefulWidget implements PreferredSizeWidget {
  final String pageTitle;
  final bool isHomePage;
  final bool showBack;

  const appBar({
    Key? key,
    required this.pageTitle,
    this.isHomePage = false,
    this.showBack = false,

  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60); // Adjusted height
}

class _CustomAppBarState extends State<appBar> {
  String displayName = '';
  String profileURL = '';
  int droid = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        DocumentSnapshot doc = await userDoc.get();
        if (doc.exists) {
          String userName = doc['name'] ?? 'User';
          setState(() {
            displayName = userName.split(' ')[0];
            profileURL = doc['profilePic'] ?? '';
            droid = doc['droids'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void profileView(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => UserInfoPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define the circle expansion animation
          const begin = 0.0;
          const end = 1.0;
          var circleTween = Tween<double>(begin: begin, end: end);
          var circleAnimation = animation.drive(circleTween);

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // Calculate the radius of the circle based on animation value
              double radius = circleAnimation.value * MediaQuery.of(context).size.longestSide;

              // Center the circle in the screen
              return Center(
                child: ClipRect(
                  child: Container(
                    width: radius * 2, // Diameter of the circle
                    height: radius * 2, // Diameter of the circle
                    color: Colors.transparent, // Background color or gradient can be added here
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PreferredSize(
        preferredSize: const Size.fromHeight(160), // Adjusted height
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          flexibleSpace: Container(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the items
              children: [
                // Title Container
                widget.isHomePage
                  ? Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Vertically center title
                      crossAxisAlignment: CrossAxisAlignment.start, // Align title to the left
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        // ),
                        Text(
                          'Graciós\n$displayName',
                          textAlign: TextAlign.left, // Adjust text alignment
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : Row(
                  children: [
                    widget.showBack
                        ? IconButton(
                      icon: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white // For dark mode
                          : Colors.black,),
                      onPressed: () => Navigator.pop(context), // Navigate back on tap
                    )
                        :SizedBox.shrink(),
                    Text(
                      widget.pageTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                // Profile Avatar
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          // onTap: () => _onProfilePicTap(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.android, // Android icon
                                  size: 40.0, // Adjust the size of the icon as needed
                                  color: Colors.green, // Adjust the color of the icon
                                ),
                                SizedBox(width: 10), // Space between the icon and the text
                                Text(
                                  droid.toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => profileView(context),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profileURL),
                            radius: 23, // Adjust the size of the profile picture
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
