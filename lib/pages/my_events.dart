import 'package:android_club_app/pages/EventDetails.dart';
import 'package:android_club_app/pages/user_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bar.dart';

class MyEvent extends StatefulWidget {
  const MyEvent({Key? key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  final List<Map<String, dynamic>> _eventData = []; // List to hold event data
  bool _isLoading = true; // Flag to track loading state
  String? _userEmail; // Variable to store user email

  // Function to fetch user email from Firestore
  Future<void> fetchUserEmail() async {
    try {
      final String userPId = getUserId(); // Assuming getUserId() fetches the user ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userPId)
          .get();

      if (userDoc.exists) {
        _userEmail = userDoc['email']; // Assuming the email is stored under 'email'
        print(_userEmail);
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }

  // Function to fetch event data from Firestore
  Future<void> fetchEventData() async {
    try {
      await fetchUserEmail(); // Fetch user email before fetching event data
      if (_userEmail == null) {
        print('User email not found.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final String userPId = getUserId(); // Assuming getUserId() fetches the user ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userPId)
          .get();

      if (userDoc.exists) {
        // Fetching the allRegisteredEvents array
        List<dynamic> allRegisteredEvents = userDoc['allRegisteredEvents'];

        // Fetch event data for each eventId in the array
        for (var eventId in allRegisteredEvents) {
          DocumentSnapshot eventDoc = await FirebaseFirestore.instance
              .collection('events') // Assuming event data is in 'events' collection
              .doc(eventId)
              .get();

          if (eventDoc.exists) {
            Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;

            // Find the logged-in user's payment status in the RegisteredUsers array using email
            String paymentStatus = 'Contact Core Team'; // Default status
            if (eventData.containsKey('Registered Users')) {
              print('Entry');
              var registeredUsers = eventData['Registered Users'] as List<dynamic>;
              var userEntry = registeredUsers.firstWhere(
                      (user) => user['email'] == _userEmail,
                  orElse: () => null);

              if (userEntry != null && userEntry.containsKey('paymentVerified')) {
                switch (userEntry['paymentVerified']) {
                  case 'Y':
                    paymentStatus = 'Verified';
                    break;
                  case 'N':
                    paymentStatus = 'Processing';
                    break;
                  default:
                    paymentStatus = 'Payment Failed';
                    break;
                }
              }
            }

            // Add event data and payment status to the list
            setState(() {
              _eventData.add({
                ...eventData,
                'eventId': eventId,
                'paymentStatus': paymentStatus,
              });
            });
          } else {
            print('No event found for eventId: $eventId');
          }
        }
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching event data: $e');
    } finally {
      // Set loading to false after data fetch is complete
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEventData(); // Fetch the event data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroAppBar(
        pageTitle: 'My Events',
        showBack: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner while data is fetched
          : _eventData.isEmpty
          ? const Center(
        child: Text(
          'Not registered in any events', // Show message if no events are found
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      )
      : ListView.builder(
        itemCount: _eventData.length,
        itemBuilder: (context, index) {
          final event = _eventData[index];
          final eventId = _eventData[index]['eventId'] as String; // Extract the eventId as a string

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetail(event: event, eventId : eventId), // Pass the event data to EventDetail page
                ),
              );
            },
            child: Card(
              color: Colors.black, // Set the background color of the card to black
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add margin for spacing
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                side: BorderSide(color: Colors.white), // Optional: Add a border to the card
              ),
              child: Padding(
                padding: const EdgeInsets.all(12), // Add padding inside the card
                child: Row(
                  children: [
                    if (event['bannerURL'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          event['bannerURL'], // Display the event image
                          height: 160,
                          width: 115,
                          fit: BoxFit.cover,
                          // Other loading and error handling code
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['name'] ?? 'No Title',
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${event['date'] ?? 'Unknown'}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Time: ${event['time'] ?? 'Unknown'}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Venue: ${event['location'] ?? 'Unknown'}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Payment Status: ${event['paymentStatus']}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )

    );
  }
}
