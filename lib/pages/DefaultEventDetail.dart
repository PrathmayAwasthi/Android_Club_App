import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bar.dart';

class Defaulteventdetail extends StatefulWidget {
  final String eventId;
  final String imageUrl; // Add the imageUrl here

  const Defaulteventdetail({
    Key? key,
    required this.eventId,
    required this.imageUrl, // Make it required
  }) : super(key: key);

  @override
  _DefaulteventdetailState createState() => _DefaulteventdetailState();
}

class _DefaulteventdetailState extends State<Defaulteventdetail> {
  bool _isLoading = true;
  Map<String, dynamic>? _eventData;
  String? _errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    try {
      DocumentSnapshot eventSnapshot =
      await _firestore.collection('events').doc(widget.eventId).get();

      if (eventSnapshot.exists) {
        setState(() {
          _eventData = eventSnapshot.data() as Map<String, dynamic>?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Event not found';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching event details: $e';
      });
      print(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AndroAppBar(
        pageTitle: 'Event Details',
        showBack: true,
          clickableIcons: false
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      )
          : _eventData != null
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use the passed imageUrl for the banner image
            if (widget.imageUrl.isNotEmpty)
              Center(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16),

            // Event details inside the card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,  // Makes the Card's width match the parent
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event name
                        Text(
                          _eventData!['name'] ?? 'Event Name',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Event date
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Date: ',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _eventData!['date'] ?? 'N/A',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 16,

                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        // Event time
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Time: ',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _eventData!['time'] ?? 'N/A',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Price: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,

                                ),
                              ),
                              TextSpan(
                                text:'INR ' + _eventData!['price'] ?? 'N/A',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 8),

                        // Event location
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Location: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,

                                ),
                              ),
                              TextSpan(
                                text: _eventData!['location'] ?? 'N/A',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        // Event price


                        SizedBox(height: 8),

                        // Event description
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Description: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,

                                ),
                              ),
                              TextSpan(
                                text: _eventData!['description'] ?? 'N/A',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 16,
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
            )


          ],
        ),
      )
          : Center(child: Text('No event data available')),
    );
  }
}
