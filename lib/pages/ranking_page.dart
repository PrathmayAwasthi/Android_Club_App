import 'package:flutter/material.dart';
import 'package:android_club_app/widgets/app_bar.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AndroAppBar(
        pageTitle: 'Ranking',
        showBack: true,
        clickableIcons: false
      ),
      body: Text("Welcome to Merch Section!!\nWe aill be live Soon"),
    );
  }
}
