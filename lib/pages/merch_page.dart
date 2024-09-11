import 'package:flutter/material.dart';
import 'package:android_club_app/widgets/app_bar.dart';

class MerchPage extends StatefulWidget {
  const MerchPage({super.key});

  @override
  State<MerchPage> createState() => _MerchPageState();
}

class _MerchPageState extends State<MerchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Home'),
      body: Text("Welcome to Merch Section!!\nWe aill be live Soon"),
    );
  }
}
