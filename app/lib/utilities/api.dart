import 'package:Stylr/main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

String _apiIP = "https://stylr.go.ro:42069";

class MyHttpOverrides extends HttpOverrides {
  // USED ONLY FOR NOT VERIFYING SSL CERTIFICATES
  // DO NOT USE THIS IN PRODUCTION OR DEPLOYMENT ENVIROMENTS!!
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future login(String username, String password) async {
  return await http.get(
    Uri.parse(_apiIP + "/api/user/login"),
    headers: {
      "username": username,
      "password": password,
    },
  );
}

Future signup(String username, String password) async {
  print("signup requested");
  return await http.get(
    Uri.parse(_apiIP + "/api/user/signup"),
    headers: {
      "username": username,
      "password": password,
    },
  );
}

Future get_blueprints(String security_token) async {
  return await http.get(
    Uri.parse(_apiIP + "/api/catalog/blueprints"),
    headers: {
      "Authorization": "Bearer $security_token"
    }
  );
}