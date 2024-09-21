import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:android_club_app/models/user.dart'; // Import the AppUser model

class UserDataManager {
  static Future<AppUser?> getUserData({bool update = false}) async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await Hive.initFlutter();
    final box = await Hive.openBox<AppUser>('users');

    if (update || !box.containsKey(userId)) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (querySnapshot.exists) {
        var userData = querySnapshot.data() as Map<String, dynamic>;
        final user = AppUser(
          id: userId,
          name: userData['name'],
          regNo: userData['regNo'],
          profilePic: userData['profilePic'],
          droids: userData['droids'],
          phone: userData['phone'],
          email: userData['email'],
          allRegisteredEvents: userData['allRegisteredEvents'] != null
              ? (userData['allRegisteredEvents'] as List<dynamic>).cast<String>()
              : [],        );
        await box.put(userId, user);
        return user;
      } else {
        return null;
      }
    } else {
      return box.get(userId);
    }
  }
}