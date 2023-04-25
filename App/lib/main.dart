// ignore_for_file: non_constant_identifier_names

import 'package:Stylr/loginPage.dart';
import 'package:Stylr/startPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'utilities.dart';

GlobalKey RootWidgetKey = GlobalKey();
Color primaryColor = const Color(0xff272324);
Color secondaryColor = const Color(0xfffeba57);
bool debugMode =
    true; // DEBUG MODE IS ONLY FOR DEVELOPMENT PORPOUSES AND NOT INTENDED TO BE ENABELD IN DEPLYOMENT!

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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {;
    return MaterialApp(
          title: 'Stylr',
          initialRoute: "/",
          routes: {
            "/": (context) => const StartPage(),
            "/login": (context) => LoginPage(),
          },
        );
  }
}
