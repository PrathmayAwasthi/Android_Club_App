import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<Map<String, String>?> showUserDetailsDialog(BuildContext context, User user, {bool showCancel = false}) async {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final UserID = user.uid;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final regNoController = TextEditingController();
  final profilePicUrl = user.photoURL ?? '';

  final regNoPattern = RegExp(r'^\d{2}[A-Z]{3}\d{5}$');

  if(!showCancel){
    nameController.text = user.displayName ?? '';
    emailController.text = user.email ?? '';
    // profilePicUrl = user.photoURL ?? '';

    final nameParts = nameController.text.split(' ');
    final lastWord = nameParts.last.toUpperCase();
    if (regNoPattern.hasMatch(lastWord)) {
      regNoController.text = lastWord;
      nameParts.removeLast();
      nameController.text = nameParts.join(' ');
      nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length),
      );
    }
  }else{
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(UserID).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        nameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        regNoController.text = userData['regNo'] ?? '';
      }
    } catch (e) {
      print("Error fetching user details from Firestore: $e");
    }
  }

  bool isPhoneValid = true;
  bool isRegNoValid = true;
  bool isRegNoEnabled = true;
  bool canToggleSwitch = !emailController.text.endsWith('@vitbhopal.ac.in');


  Future<void> writeDet() async {
    await _firestore.collection('users').doc(UserID).set({
      'email': emailController.text,
      'name': nameController.text,
      'phone': phoneController.text,
      'profilePic': profilePicUrl,
      'regNo': regNoController.text,
    });
  }

  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black38.withOpacity(0.8),
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter Your Details', textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePicUrl),
                      radius: 40,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: emailController,
                      enabled: canToggleSwitch,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        errorText: isPhoneValid ? null : "Your number looks small Buddy🤏",
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text("VIT Student"),
                          Transform.scale(
                              scale: 0.8,
                              child: Switch(

                                value: isRegNoEnabled,
                                onChanged: canToggleSwitch
                                    ? (value) {
                                  setState(() {
                                    isRegNoEnabled = value;
                                  });
                                }: null,
                                activeTrackColor: Colors.teal,
                              )
                          )

                        ],
                      ),
                    ),
                    TextField(
                      controller: regNoController,
                      decoration: InputDecoration(
                        labelText: 'Reg No',
                        errorText: isRegNoValid ? null : "Who You tryna play with Huh😏",
                      ),
                      enabled: isRegNoEnabled,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        TextInputFormatter.withFunction(
                              (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                            selection: newValue.selection,
                          ),
                        ),
                      ],
                    ),



                  ],
                ),
              ),
              actions: [
                if (showCancel)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.teal // Color for dark theme
                              : Colors.black // Color for light theme
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isPhoneValid = phoneController.text.length == 10;
                      isRegNoValid = regNoPattern.hasMatch(regNoController.text);
                    });

                    if (isPhoneValid && (isRegNoValid || !isRegNoEnabled)) {
                      await writeDet();
                      Navigator.of(context).pop();
                    }
                  },

                  child: Text(
                    'Submit',
                    // style: Theme.of(context).textTheme.titleMedium,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.teal // Color for dark theme
                          : Colors.black // Color for light theme
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
