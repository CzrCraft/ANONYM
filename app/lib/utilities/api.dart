import 'package:http/http.dart' as http;
import 'dart:io';

String _apiIP = "https://192.168.100.15:42069";

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
    Uri.parse(_apiIP + "/api/user/login"),
    headers: {
      "username": username,
      "password": password,
    },
  );
}

Future signup(String username, String password) async {
  print("signup requested");
  return http.get(
    Uri.parse(_apiIP + "/api/user/signup"),
    headers: {
      "username": username,
      "password": password,
    },
  );
}
