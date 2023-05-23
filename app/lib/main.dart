// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'utilities.dart';
import 'pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
GlobalKey RootWidgetKey = GlobalKey();
Color primaryColor = Color(0xFFFE6F27);
Color secondaryColor = Color(0xFF2F2F2F);
bool debugMode = true; // DEBUG MODE IS ONLY FOR DEVELOPMENT PORPOUSES AND NOT INTENDED TO BE ENABELD IN AN DEPLOYMENT ENV!
String api_token = "";
String username = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (debugMode) {
    HttpOverrides.global = new MyHttpOverrides();
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
  runApp(RootWidget(key: RootWidgetKey));
}

class RootWidget extends StatelessWidget {
  RootWidget({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final StartPageKey = new GlobalKey();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylr',
      initialRoute: "/",
      routes: {
        "/": (context) => new StartPage(key: StartPageKey),
        "/login": (context) => LoginPage(),
      },
    );
  }
}
