import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';

class LoadingDots extends StatelessWidget {
  const LoadingDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: primaryColor,
        child: Center(
            child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText("...",
                speed: const Duration(milliseconds: 500),
                textStyle: TextStyle(
                    fontSize: 80.0,
                    color: secondaryColor,
                    decoration: TextDecoration.none,
                    backgroundColor: Colors.transparent))
          ],
          repeatForever: true,
          totalRepeatCount: 100000,
          pause: const Duration(milliseconds: 500),
        )));
  }
}

class CircleRevealClipper extends CustomClipper<Path> {
  final center;
  final radius;

  CircleRevealClipper({this.center, this.radius});

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(radius: radius, center: center));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

Route animatedRoute(Widget p_widget, {p_widgetKey}) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 650),
    reverseTransitionDuration: Duration(milliseconds: 450),
    opaque: false,
    barrierDismissible: false,
    pageBuilder: (context, animation, secondaryAnimation) => p_widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var screenSize = MediaQuery.of(context).size;
      Offset center = Offset(screenSize.width / 2, screenSize.height / 2);
      double beginRadius = 0.0;
      double endRadius = screenSize.height * 1.2;

      var tween = Tween<double>(begin: beginRadius, end: endRadius);
      double radiusTweenAnimation = animation.drive<double>(tween).value;

      return ClipPath(
        clipper:
            CircleRevealClipper(radius: radiusTweenAnimation, center: center),
        child: child,
      );
    },
  );
}