// ignore_for_file: non_constant_identifier_names

import 'package:Stylr/loginPage.dart';
import 'package:Stylr/startPage.dart';
import 'package:flutter/material.dart';

GlobalKey RootWidgetKey = GlobalKey();
Color primaryColor = const Color(0xff272324);
Color secondaryColor = const Color(0xfffeba57);
void main() {
  runApp(RootWidget(key: RootWidgetKey));
}

Route _createRoute(Widget page2) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page2,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class RootWidget extends StatelessWidget {
  RootWidget({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Stylr', initialRoute: "/", routes: {
        "/": (context) => const StartPage(),
        "/login": (context) => const LoginPage(),
      },
      
    );
  }
}
