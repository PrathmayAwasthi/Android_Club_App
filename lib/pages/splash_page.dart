import 'package:android_club_app/auth/firebase_auth/CheckAuth.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with the splash video
    _controller = VideoPlayerController.asset('assets/images/splash.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI after initialization
        _controller.play(); // Automatically start playing the video
      });

    _controller.setLooping(false); // Video won't loop

    // Listener to detect when the video completes
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // When video completes, delay slightly to ensure transition is smooth
        Future.delayed(Duration(milliseconds: 100), () {
          // Navigate with bottom-to-top animation after the video
          Navigator.of(context).pushReplacement(_createRoute());
        });
      }
    });
  }

  // Custom route with bottom-to-top slide animation
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CheckAuth(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Start from the bottom
        const end = Offset.zero; // End at normal position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 700), // Duration of slide transition
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF203828), // Set your custom background color
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(), // Display an empty container until the video is ready
      ),
    );
  }
}
