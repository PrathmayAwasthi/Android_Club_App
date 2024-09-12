import 'package:flutter/material.dart';
import 'package:android_club_app/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:android_club_app/auth/firebase_auth/userDetDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: appBar(
        pageTitle: 'Set',
        showBack: true
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
              // Align(
              //   alignment: Alignment(-0.9,0.1), // Adjust this to position below the AppBar
              //   child: Transform.scale(
              //     scale: 1.5, // 1.0 is the default size, 1.5 makes it 50% larger
              //     child: BackButton(),
              //   ),
              // ),
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
                              Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // onTap: () async{
                                  //   User? user = FirebaseAuth.instance.currentUser;
                                  //   showUserDetailsDialog(context, user!, showCancel: true);
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
                                        child: Text(
                                          'About Us',
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
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: DefaultTextStyle(
                                          style: TextStyle(color: Colors.white),
                                          child: const Text("Warning!"),
                                        ),
                                        content: DefaultTextStyle(
                                          style: TextStyle(color: Colors.white),
                                          child: const Text("You Sure wanna do that🤨"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: DefaultTextStyle(
                                              style: TextStyle(color: Colors.white),
                                              child: const Text("Cancel"),
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
                                            child: DefaultTextStyle(
                                              style: TextStyle(color: Colors.white),
                                              child: const Text("Logout"),
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
        child: FloatingActionButton(
          onPressed: () async{
            User? user = FirebaseAuth.instance.currentUser;
            showUserDetailsDialog(context, user!, showCancel: true);
          },
          child: Icon(Icons.edit),  // Icon inside the FAB
          backgroundColor: Colors.black12,  // Background color of the FAB
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
