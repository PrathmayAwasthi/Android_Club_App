import 'dart:io';
import 'package:android_club_app/pages/user_info_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/app_bar.dart';

class EventDetail extends StatefulWidget {
  final Map<String, dynamic> event;
  final String eventId;

  const EventDetail({Key? key, required this.event, required this.eventId}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  bool _isLoading = true;
  bool _isEditing = false;
  String? _userEmail;
  Map<String, dynamic>? _registeredUserDetails;
  File? _newImage; // For the new image file
  String? _newImageURL; // For the uploaded image URL

  // TextEditingControllers for the form fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _regNoController = TextEditingController();
  TextEditingController _upiTransactionIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _regNoController.dispose();
    _upiTransactionIdController.dispose();
    super.dispose();
  }

  Future<void> fetchUserEmail() async {
    try {
      final String userPId = getUserId();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userPId)
          .get();

      if (userDoc.exists) {
        _userEmail = userDoc['email'];
        fetchRegisteredUserDetails(); // Fetch details of the registered user
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }

  Future<void> fetchRegisteredUserDetails() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .get();

      if (eventDoc.exists) {
        List<dynamic> registeredUsers = eventDoc['Registered Users'];

        for (var user in registeredUsers) {
          if (user['email'] == _userEmail) {
            setState(() {
              _registeredUserDetails = user;
              _isLoading = false;

              // Initialize the controllers with user data
              _nameController.text = _registeredUserDetails!['name'];
              _emailController.text = _registeredUserDetails!['email'];
              _phoneController.text = _registeredUserDetails!['phone'];
              _regNoController.text = _registeredUserDetails!['regNo'];
              _upiTransactionIdController.text = _registeredUserDetails!['upiTransactionId'];
            });
            break;
          }
        }

        if (_registeredUserDetails == null) {
          print('User is not registered for this event.');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Event document does not exist.');
      }
    } catch (e) {
      print('Error fetching registered user details: $e');
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      String fileName = 'EventPayments/${widget.eventId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(image);

      _newImageURL = await snapshot.ref.getDownloadURL();
      print('Image uploaded: $_newImageURL');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _submitChanges() async {
    try {
      // Upload new image if exists
      if (_newImage != null) {
        await _uploadImage(_newImage!);
      }

      // Reference to the event document
      DocumentReference eventDocRef =
      FirebaseFirestore.instance.collection('events').doc(widget.eventId);

      // Get the event document snapshot
      DocumentSnapshot eventDoc = await eventDocRef.get();

      if (eventDoc.exists) {
        List<dynamic> registeredUsers = eventDoc['Registered Users'];

        // Find the index of the user in the Registered Users array
        int userIndex = registeredUsers.indexWhere((user) => user['email'] == _userEmail);

        if (userIndex != -1) {
          // Update the user's details in the array
          registeredUsers[userIndex]['name'] = _nameController.text;
          registeredUsers[userIndex]['email'] = _emailController.text;
          registeredUsers[userIndex]['phone'] = _phoneController.text;
          registeredUsers[userIndex]['regNo'] = _regNoController.text;
          registeredUsers[userIndex]['upiTransactionId'] = _upiTransactionIdController.text;

          // Update payment screenshot if a new one was uploaded
          if (_newImageURL != null) {
            registeredUsers[userIndex]['paymentscreenshot'] = _newImageURL;
          }

          // Write the updated array back to Firestore
          await eventDocRef.update({
            'Registered Users': registeredUsers,
          });

          // Provide feedback and exit edit mode
          print('User details updated successfully');
          _toggleEdit();
        } else {
          print('User not found in the Registered Users array.');
        }
      } else {
        print('Event document does not exist.');
      }
    } catch (e) {
      print('Error updating user details: $e');
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.event['bannerURL'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.event['bannerURL'],
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            // Event details
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${widget.event['name'] ?? 'Unknown'}',
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${widget.event['date'] ?? 'Unknown'}',
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Time: ${widget.event['time'] ?? 'Unknown'}',
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Venue: ${widget.event['location'] ?? 'Unknown'}',
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Payment Status: ${widget.event['paymentStatus']}',
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Registered user details
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_registeredUserDetails != null) ...[
                      Text(
                        'Registered User Details:',
                        style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        readOnly: !_isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        readOnly: !_isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                        ),
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _regNoController,
                        readOnly: !_isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Registration No',
                        ),
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _upiTransactionIdController,
                        readOnly: !_isEditing,
                        decoration: const InputDecoration(
                          labelText: 'UPI Transaction ID',
                        ),
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (_registeredUserDetails!['paymentscreenshot'] !=
                          null)
                        _newImage == null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            _registeredUserDetails![
                            'paymentscreenshot'],
                            fit: BoxFit.cover,
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(
                            _newImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (_isEditing)
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Pick New Image'),
                        ),
                    ] else
                      const Text('You are not registered for this event.',
                          style: TextStyle(color: Colors.red)),

                    const SizedBox(height: 16),

                    // Edit and Submit buttons
                    if (_registeredUserDetails != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(widget.event['paymentStatus']!="Verified")
                            ElevatedButton(
                              onPressed: _toggleEdit,
                              child: Text(_isEditing ? 'Cancel' : 'Edit'),
                            ),
                          if (_isEditing)
                            ElevatedButton(
                              onPressed: _submitChanges,
                              child: const Text('Submit'),
                            ),
                        ],
                      ),

                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
