import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/pages/user_info_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_bar.dart';

class RegForm extends StatelessWidget {
  const RegForm({super.key, required this.eventId, required this.imageUrl});
  final String eventId; // Add a field for eventId
  final String imageUrl; // Add a field for imageUrl

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Registration Form';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        fontFamily: 'Poppins', // Set the font family to Poppins
        // scaffoldBackgroundColor: Theme.of(context).brightness == Brightness.light
        //     ? Colors.white // For dark mode
        //     : Colors.black, // Set the background color to #121212
      ),
      home: Scaffold(
        appBar: appBar(
            pageTitle: 'Set',
            showBack: true
        ),
        body: MyCustomForm(eventId: eventId, imageUrl: imageUrl), // Pass eventId and imageUrl to MyCustomForm
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key, required this.eventId, required this.imageUrl});
  final String eventId; // Add eventId field
  final String imageUrl; // Add imageUrl field

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final regNoController = TextEditingController();
  final upiTransactionIdController = TextEditingController();
  File? _image;
  String _fileName = 'No file chosen';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Fetch user details when the form initializes
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      // Replace 'userIdentifier' with the actual field you want to query, like email or registration number
      final String userPId = getUserId();
      final userDoc = await _firestore.collection('users').doc(userPId).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        // Update the text controllers with the retrieved data
        nameController.text = userData['name'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        regNoController.text = userData['regNo'] ?? '';
        emailController.text = userData['email'] ?? '';
        // You may need to handle the case where these fields are null
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the retrieval
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the user data map
      Map<String, String> userData = {
        'email': emailController.text,
        'name': nameController.text,
        'phone': phoneController.text,
        'regNo': regNoController.text,
        'upiTransactionId': upiTransactionIdController.text,
        'paymentVerified': 'N', // Update this field based on the payment verification status
        'paymentscreenshot': '', // Initialize the paymentscreenshot field
      };

      try {
        // Navigate to EventPayments folder and create a folder with eventId
        final storageRef = FirebaseStorage.instance.ref();
        final eventFolderRef = storageRef.child('EventPayments/${widget.eventId}'); // Reference to the event folder

        // Define the path and upload the image
        final fileRef = eventFolderRef.child('${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}'); // Create a unique file name using timestamp
        final uploadTask = fileRef.putFile(_image!); // Upload the image

        await uploadTask.whenComplete(() async {
          if (uploadTask.snapshot.state == TaskState.success) {
            // Get the download URL of the uploaded image
            final imageUrl = await fileRef.getDownloadURL();
            userData['paymentscreenshot'] = imageUrl; // Update the paymentscreenshot field with the image URL

            // Update the existing document in the "events" collection with the ID from widget.eventId
            await _firestore.collection('events').doc(widget.eventId).update({
              // Add the email to the Registered Emails array
              'Registered Emails': FieldValue.arrayUnion([emailController.text]),
              // Add the user data map to the Registered Users array
              'Registered Users': FieldValue.arrayUnion([userData]),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data updated successfully')),
            );

            // Redirect to HomePage on success
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()), // Replace with your HomePage widget
            );
          } else {
            // Handle the error case
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error uploading image')),
            );
          }
        });
      } catch (e) {
        // Handle any errors during the upload or database update process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _fileName = pickedImage.name; // Update the file name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.imageUrl, // Use the imageUrl passed from RegForm
                fit: BoxFit.cover,
              ), // Add image view

              const SizedBox(height: 20), // Add space between image and form fields

              // Email Box
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(), // Set border color to white
                  ),
                  labelText: 'Email',
                  labelStyle: const TextStyle(), // Set label text color to white
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set enabled border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set focused border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                controller: emailController,
                style: GoogleFonts.openSans(fontSize: 18),
              ),

              const SizedBox(height: 20), // Add space between text fields

              // Name Box
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(), // Set border color to white
                  ),
                  labelText: 'Name',
                  labelStyle: const TextStyle(), // Set label text color to white
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set enabled border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set focused border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                controller: nameController,
                style: GoogleFonts.openSans(fontSize: 18),
              ),

              const SizedBox(height: 20), // Add space between text fields

              // Phone Box
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(), // Set border color to white
                  ),
                  labelText: 'Phone',
                  labelStyle: const TextStyle(), // Set label text color to white
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set enabled border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set focused border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                controller: phoneController,
                style: GoogleFonts.openSans(fontSize: 18),
              ),

              const SizedBox(height: 20), // Add space between text fields

              // Registration Number Box
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(), // Set border color to white
                  ),
                  labelText: 'Registration Number',
                  labelStyle: const TextStyle(), // Set label text color to white
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set enabled border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set focused border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a registration number';
                  }
                  return null;
                },
                controller: regNoController,
                style: GoogleFonts.openSans(fontSize: 18),
              ),

              const SizedBox(height: 20), // Add space between text fields

              // UPI Transaction ID Box
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(), // Set border color to white
                  ),
                  labelText: 'UPI Transaction ID',
                  labelStyle: const TextStyle(), // Set label text color to white
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set enabled border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(), // Set focused border color to white
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a UPI transaction ID';
                  }
                  return null;
                },
                controller: upiTransactionIdController,
                style: GoogleFonts.openSans(fontSize: 18),
              ),

              const SizedBox(height: 40), // Add space between text fields

              // Payment Screenshot Button
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _openImagePicker,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/upload.svg', height: 20, width: 20), // Replace with your SVG file
                        const SizedBox(width: 10), // Add some space between the icon and the text
                        const Text('Upload'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(_fileName),
                ],
              ),

              if (_image != null) ...[
                const SizedBox(height: 10),
                Image.file(_image!, height: 100),
              ],

              const SizedBox(height: 10), // Add space between image and submit button

              // Payment Screenshot Label
              Padding(
                padding: const EdgeInsets.only(left: 8.0), // Add left margin
                child: Text(
                  'Upload Payment Screenshot here',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    // color: Colors.white,
                  ),
                ),
              ),

              // Submit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: _submitForm, // Call the _submitForm method
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

