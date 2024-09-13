import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/pages/polls_page.dart';
import 'package:android_club_app/pages/merch_page.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 1;

  PageController pageController = PageController(initialPage: 1);

  List<Widget> widgets = [
    const Text('Home'),
    const Text('Polls'),
    const Text('Merch'),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: const [

              PollsPage(),
              HomePage(),
              MerchPage(),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.quiz),
                        ), label: 'Polls'),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.home),
                        ), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.business_center),
                        ), label: 'Merch'),
                  ],
                  currentIndex: selectedIndex,
                  selectedItemColor: const Color(0xFF34a853),
                  unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
                  onTap: onItemTapped,
                  backgroundColor: Theme.of(context).colorScheme.surface, // Change color to your desired color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
