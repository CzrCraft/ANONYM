// ignore_for_file: non_constant_identifier_names

import 'package:Stylr/loginPage.dart';
import 'package:Stylr/startPage.dart';
import 'package:flutter/material.dart';

GlobalKey RootWidgetKey = GlobalKey();
Color primaryColor = const Color(0xff272324);
Color secondaryColor = const Color(0xfffeba57);

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

Route animatedRoute(Widget p_widget) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 650),
    reverseTransitionDuration: Duration(milliseconds: 450),
    opaque: false,
    barrierDismissible: false,
    pageBuilder: (context, animation, secondaryAnimation) => p_widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var screenSize = MediaQuery.of(context).size;
      Offset center = Offset(screenSize.width/2, screenSize.height/2);
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

// Route animatedRoute(Widget widget) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimatn) => widget,
//     transitionDuration: Duration(milliseconds: 1000),
//     opaque: false,
//     barrierDismissible: false,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var screenSize = MediaQuery.of(context).size;
//       Offset center = Offset(screenSize.width - 40, screenSize.height - 40);
//       double beginRadius = 0.0;
//       double endRadius = screenSize.height * 1.2;

//       var tween = Tween<double>(begin: beginRadius, end: endRadius);
//       var radiusTweenAnimation = animation.drive(tween);

//       return ClipPath(
//         clipper:
//             CircleRevealClipper(radius: radiusTweenAnimation, center: center),
//         child: child,
//       );
//     },
//   );
// }

void main() {
  runApp(RootWidget(key: RootWidgetKey));
}

class RootWidget extends StatelessWidget {
  RootWidget({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylr',
      initialRoute: "/",
      routes: {
        "/": (context) => const StartPage(),
        "/login": (context) => const LoginPage(),
      },
    );
  }
}
