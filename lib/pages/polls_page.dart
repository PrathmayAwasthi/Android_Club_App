import 'package:flutter/material.dart';
import 'package:android_club_app/widgets/app_bar.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({super.key});

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Home'),
      body: Text("Welcome to Polls Section!!\nWe aill be live Soon"),
    );
  }
}
