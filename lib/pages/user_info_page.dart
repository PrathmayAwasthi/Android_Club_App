import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final String userId = 'CLCHtnsJGfUFE9XRFkHztCf68kD3'; // Replace with actual user ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              // Top Center Alignment
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture with Border
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userData['profilePic']),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 16),
                      // Name
                      Text(
                        userData['name'],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      // Email
                      Text(
                        userData['email'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      // Bio
                      Text(
                        userData['regNo'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(16.0),
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[100],
                      //     borderRadius: BorderRadius.circular(8.0),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.withOpacity(0.5),
                      //         spreadRadius: 2,
                      //         blurRadius: 5,
                      //         offset: Offset(0, 3),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Text(
                      //     userData['regNo'],
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.black87,
                      //     ),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      // SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Spacer(), // Pushes the bottom content to the bottom
              // Bottom Center Alignment
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: (){

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Logout  ',
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/logout.svg',
                          width: 24,
                          height: 24,
                        ),
                      ]
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
