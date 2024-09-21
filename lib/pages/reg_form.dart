import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/pages/user_info_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_club_app/models/user.dart';
import 'package:android_club_app/auth/user_data_manager.dart';

import '../widgets/app_bar.dart';

class RegForm extends StatelessWidget {
  const RegForm({super.key, required this.eventId, required this.imageUrl});
  final String eventId; // Add a field for eventId
  final String imageUrl; // Add a field for imageUrl

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AndroAppBar(
          pageTitle: 'Form',
          showBack: true,
          clickableIcons: false
      ),
      body: MyCustomForm(eventId: eventId, imageUrl: imageUrl), // Pass eventId and imageUrl to MyCustomForm
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
  AppUser? _user;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final regNoController = TextEditingController();
  final upiTransactionIdController = TextEditingController();
  File? _image;
  String _fileName = 'No file chosen';
  bool isRegistered = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = await UserDataManager.getUserData();
    setState(() {
      _user = user;
      nameController.text = _user!.name;
      phoneController.text = _user!.phone;
      regNoController.text = _user!.regNo;
      emailController.text = _user!.email;
      List<dynamic> allRegisteredEvents = _user!.allRegisteredEvents;
      if (allRegisteredEvents.contains(widget.eventId)){
        isRegistered = true;
      }
    });
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

            // Add logic to update the user's document with the eventId
            final String userPId = _user!.id;
            print('User ID: $userPId');

            await _firestore.collection('users').doc(userPId).update({
              'allRegisteredEvents': FieldValue.arrayUnion([widget.eventId]),

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
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // adjust the value to your liking
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        "Bank Name - Indian Bank, VIT Bhopal University, Kothri kalan",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SelectableText(
                        'Name on Bank - Android Club', // Replace with dynamic location if available
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SelectableText(
                        'Account Number - 6565521552', // Replace with dynamic date if available
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SelectableText(
                        'IFSC - IDIB000V143', // Replace with dynamic location if available
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),


              if(!isRegistered)
                Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle, // Use dynamic label color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Adjusts border color dynamically based on theme
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.teal : Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      controller: emailController,
                      style: GoogleFonts.openSans(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 20), // Add space between text fields

                    // Name Box
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle, // Use dynamic label color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Adjusts border color dynamically based on theme
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.teal : Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      controller: nameController,
                      style: GoogleFonts.openSans(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 20), // Add space between text fields

                    // Phone Box
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle, // Dynamic label color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Border color based on theme
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Enabled border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.teal : Colors.black,
                            width: 2.0,
                          ), // Focused border color
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                      controller: phoneController,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface, // Dynamic text color
                      ),
                    ),
                    const SizedBox(height: 20), // Add space between text fields

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Registration Number',
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle, // Dynamic label color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Border color based on theme
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Enabled border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.teal : Colors.black,
                            width: 2.0,
                          ), // Focused border color
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a registration number';
                        }
                        return null;
                      },
                      controller: regNoController,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface, // Dynamic text color
                      ),
                    ),
                    const SizedBox(height: 20), // Add space between text fields

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'UPI Transaction ID',
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle, // Dynamic label color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Border color based on theme
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ), // Enabled border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.teal : Colors.black,
                            width: 2.0,
                          ), // Focused border color
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a UPI transaction ID';
                        }
                        return null;
                      },
                      controller: upiTransactionIdController,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface, // Dynamic text color
                      ),
                    ),
                    const SizedBox(height: 40), // Add space between text fields

                    // Payment Screenshot Button
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _openImagePicker,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Set the background color to white
                            foregroundColor: Colors.black,
                          ),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Set the background color to white
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                const Center(
                  child: Text(
                      "You are Already Registered Bud!!"
                  ),
                )
              // Email Box



            ],
          ),
        ),
      ),
    );
  }
}

