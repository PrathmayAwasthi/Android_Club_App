import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_club_app/widgets/app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
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

class _RankingPageState extends State<RankingPage> {
  final String userPId = getUserId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AndroAppBar(
        pageTitle: 'Ranking',
        showBack: true,
        clickableIcons: false,
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(userPId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User not found'));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 25, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // User Details Section (Fixed, Not Scrollable)
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Profile Picture with Border
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(userData['profilePic']),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  userData['name'],
                                  style: GoogleFonts.openSans(
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  userData['regNo'],
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Droids: ${userData['droids'].toString()}",
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    Text(
                      "Leaderboards",
                      style: GoogleFonts.openSans(
                        fontSize: 24,
                      ),
                    ),
                    Expanded(
                      // Scrollable leaderboard section
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: getTopUsersByDroids(), // Fetch top users
                        builder: (context, leaderboardSnapshot) {
                          if (leaderboardSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!leaderboardSnapshot.hasData || leaderboardSnapshot.data == null) {
                            return const Center(child: Text('No leaderboard data available'));
                          }

                          var topUsers = leaderboardSnapshot.data!;

                          return SingleChildScrollView(
                            child: Column(
                              children: List.generate(topUsers.length, (index) {
                                var user = topUsers[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20), // Rounded corners
                                    side: BorderSide(color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white24 // For dark mode
                                        : Colors.black12), // Optional: Add a border to the card
                                  ),
                                  // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                  elevation: 0,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(user['profilePic']),
                                    ),
                                    title: Text(user['name'],style: GoogleFonts.poppins(),),
                                    subtitle: Text('Droids: ${user['droids']}'),
                                    trailing: Text(
                                      '#${index + 1}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                );
                              }),

                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getTopUsersByDroids() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('droids', descending: true)
        .limit(10)  // Limit to top 10 users
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}




