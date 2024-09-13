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
    return const Scaffold(
      appBar: AndroAppBar(
        pageTitle: 'Merchandise',
      ),
      body: Center(
        child: Text(
          "Welcome to Merchandise Section!!\nWe will be live Soon",
          style: TextStyle(fontSize: 24),
        ),
      ),    );
  }
}
