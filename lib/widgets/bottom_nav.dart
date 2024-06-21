import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/pages/photo_gallery_page.dart';
import 'package:android_club_app/pages/user_info_page.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  PageController pageController = PageController();

  List<Widget> widgets = [
    const Text('Home'),
    const Text('Gallery'),
    const Text('More'),
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
              HomePage(),
              PhotoGalleryPage(),
              UserInfoPage(),
            ],
          ),
          Positioned(
            left: 50,
            right: 50,
            bottom: 30,
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
                        icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.picture_in_picture_sharp), label: 'Gallery'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.more), label: 'More'),
                  ],
                  currentIndex: selectedIndex,
                  selectedItemColor: Color(0xFF0D99FF),
                  unselectedItemColor: Colors.grey,
                  onTap: onItemTapped,
                  backgroundColor: const Color(
                      0xFF132D1C), // Change color to your desired color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
