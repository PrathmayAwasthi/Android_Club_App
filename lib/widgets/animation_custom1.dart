import 'package:flutter/material.dart';

class Animation1Route extends PageRouteBuilder {
  final Widget enterWidget;
  final double hor;
  final double ver;

  Animation1Route({required this.enterWidget, this.hor=0.0,this.ver=0.0})
      : super(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) => enterWidget,
    transitionDuration: const Duration(milliseconds: 1500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      animation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastLinearToSlowEaseIn,
          reverseCurve: Curves.fastOutSlowIn);
      return ScaleTransition(
          alignment: Alignment(hor, ver), // Use hor and ver to determine the alignment
          scale: animation,
          child: child);
    },
  );
}