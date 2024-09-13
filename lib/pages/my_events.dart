import 'package:android_club_app/pages/user_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

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
      appBar: appBar(
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
          return Card(
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
                  // Image on the left side
                  if (event['bannerURL'] != null) // Check if bannerUrl exists
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        event['bannerURL'], // Display the event image
                        height: 160,
                        width: 115,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Return the image once loaded
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null, // Display progress while loading
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ), // Show a placeholder if the image fails to load
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 12), // Space between image and details
                  // Event details on the right side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['name'] ?? 'No Title', // Display event name
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set font color to white
                          ),
                        ),
                        const SizedBox(height: 4), // Space between title and date
                        Text(
                          'Date: ${event['date'] ?? 'Unknown'}', // Display event date
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Set font color to white
                          ),
                        ),
                        const SizedBox(height: 4), // Space between date and time
                        Text(
                          'Time: ${event['time'] ?? 'Unknown'}', // Display event time
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Set font color to white
                          ),
                        ),
                        const SizedBox(height: 4), // Space between time and venue
                        Text(
                          'Venue: ${event['location'] ?? 'Unknown'}', // Display event venue
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Set font color to white
                          ),
                        ),
                        const SizedBox(height: 4), // Space between venue and payment status
                        Text(
                          'Payment Status: ${event['paymentStatus']}', // Display payment status
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Set font color to white
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
