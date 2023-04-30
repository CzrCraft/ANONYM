import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class MyHttpOverrides extends HttpOverrides {
  // USED ONLY FOR NOT VERIFYING SSL CERTIFICATES
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future login(String username, String password) async {
  return http.get(
    Uri.parse("https://stylr.go.ro:42069/api/user/login"),
    headers: {
      "username": username,
      "password": password,
    },
  );
}

Future signup(String username, String password) async {
  print("signup requested");
  return http.get(
    Uri.parse("https://stylr.go.ro:42069/api/user/signup"),
    headers: {
      "username": username,
      "password": password,
    },
  );
}
