// models/user.dart
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class AppUser {
  @HiveField(0)
  String id;

  @HiveField(1)
  String regNo;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String profilePic;

  @HiveField(4)
  String name;

  @HiveField(5)
  String email;

  @HiveField(6)
  List<String> allRegisteredEvents;

  @HiveField(7)
  int droids;

  AppUser({
    required this.id,
    required this.regNo,
    required this.phone,
    required this.profilePic,
    required this.name,
    required this.email,
    required this.allRegisteredEvents,
    required this.droids,
  });
}