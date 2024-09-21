import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_club_app/widgets/app_bar.dart';
import 'package:android_club_app/models/user.dart';
import 'package:android_club_app/auth/user_data_manager.dart';
import 'package:google_fonts/google_fonts.dart';


class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserDataManager.getUserData();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AndroAppBar(
        pageTitle: 'Ranking',
        showBack: true,
        clickableIcons: false,
      ),
      body: Center(
        child: _user != null
            ? Align(
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
                              image: NetworkImage(_user!.profilePic),
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
                              _user!.name,
                              style: GoogleFonts.openSans(
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _user!.regNo,
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Droids: ${_user!.droids.toString()}",
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
        )
            : const Center(child: CircularProgressIndicator()),
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