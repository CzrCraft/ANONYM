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
  return await http.get(Uri.parse(_apiIP + "/api/catalog/blueprints"),
      headers: {"Authorization": "Bearer $security_token"});
}

Future get_blueprint(String security_token, String printify_id) async {
  return await http.get(Uri.parse(_apiIP + "/api/catalog/blueprint"), headers: {
    "Authorization": "Bearer $security_token",
    "printify_id": printify_id
  });
}

void ping_api(String security_token, Function callback) async {
  http.Response result =
      await http.get(Uri.parse(_apiIP + "/api/ping"), headers: {
    "Authorization": "Bearer $security_token",
  });
  if (result.statusCode == 200) {
    callback(true);
  } else {
    callback(false);
  }
}
