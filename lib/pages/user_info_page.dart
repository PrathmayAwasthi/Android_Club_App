import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_club_app/widgets/app_bar.dart';
import 'package:android_club_app/widgets/animation_custom1.dart';
import 'package:android_club_app/pages/about_us_page.dart';
import 'package:android_club_app/pages/my_events.dart';
import 'package:android_club_app/auth/firebase_auth/userDetDialog.dart';
import 'package:android_club_app/auth/firebase_auth/CheckAuth.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

String getUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String uid = user.uid;
    return uid;
  } else {
    return "n";
  }
}

class _UserInfoPageState extends State<UserInfoPage> {

  final String userPId = getUserId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AndroAppBar(
        pageTitle: 'Settings',
        showBack: true,
        clickableIcons: false
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userPId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Top Center Alignment
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 30, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture with Border
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData['profilePic']),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        userData['name'],
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Email
                      Text(
                        userData['email'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Bio
                      Text(
                        userData['regNo'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Divider(
                      //   thickness: 1,
                      //   color: Theme.of(context).colorScheme.secondary,
                      // ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      Animation1Route(
                                        enterWidget: const MyEvent(),
                                        hor: -0.65,
                                        ver: 0.05
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.event,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                                        child: Text(
                                          'My Events',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // onTap: () {
                                  //   Navigator.of(context).push(
                                  //     Animation1Route(
                                  //       enterWidget: MyEvent(),
                                  //     ),
                                  //   );
                                  // },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.photo,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                                        child: Text(
                                          'Event Gallery',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      Animation1Route(
                                        enterWidget: const AboutUs(),
                                          hor: -0.65,
                                          ver: 0.35
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.info_outlined,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const AboutUs(), // Replace with your About Us page widget
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'About Us',
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              // Divider(
                              //   thickness: 1,
                              //   color: Theme.of(context).colorScheme.secondary,
                              // ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // onTap: () {
                                  //   Navigator.of(context).push(
                                  //     Animation1Route(
                                  //       enterWidget: MyEvent(),
                                  //     ),
                                  //   );
                                  // },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.support_rounded,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                                        child: Text(
                                          'Support',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Divider(
                              //   thickness: 1,
                              //   color: Theme.of(context).colorScheme.secondary,
                              // ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // onTap: () {
                                  //   Navigator.of(context).push(
                                  //     Animation1Route(
                                  //       enterWidget: MyEvent(),
                                  //     ),
                                  //   );
                                  // },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.share_outlined,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                                        child: Text(
                                          'Share Us',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Divider(
                              //   thickness: 1,
                              //   color: Theme.of(context).colorScheme.secondary,
                              // ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // onTap: () {
                                  //   Navigator.of(context).push(
                                  //     Animation1Route(
                                  //       enterWidget: MyEvent(),
                                  //     ),
                                  //   );
                                  // },
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const DefaultTextStyle(
                                          style: TextStyle(color: Colors.white),
                                          child: Text("Warning!"),
                                        ),
                                        content: const DefaultTextStyle(
                                          style: TextStyle(color: Colors.white),
                                          child: Text("You Sure wanna do that🤨"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const DefaultTextStyle(
                                              style: TextStyle(color: Colors.white),
                                              child: Text("Cancel"),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await FirebaseAuth.instance.signOut();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const CheckAuth()),
                                              );
                                            },
                                            child: const DefaultTextStyle(
                                              style: TextStyle(color: Colors.white),
                                              child: Text("Logout"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.logout,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                                        child: Text(
                                          'Logout',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 10, 30, 0),
              )
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          right: 25.0,
          top: 150.0,
        ),
        child: Transform.scale(
          scale: 0.8, // Adjust the scale factor to achieve the desired size
          child: FloatingActionButton(
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              showUserDetailsDialog(context, user!, showCancel: true);
            },
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white12 // For dark mode
                : Colors.black12,
            child: Icon(Icons.edit, color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // For dark mode
                : Colors.black,
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
