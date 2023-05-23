import 'package:Stylr/main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:Stylr/utilities.dart';
import 'package:flutter/material.dart';

String _apiIP = "https://stylr.go.ro:42069";
String apiIP = _apiIP;
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

void get_variants(String security_token, String blueprintID, Function callback) async {
  http.Response result =
      await http.get(Uri.parse(_apiIP + "/api/catalog/get_variants"), headers: {
    "Authorization": "Bearer $security_token",
    "printify_id": blueprintID,
  });
  if (result.statusCode == 200) {
    callback(result.body);
  } else {
    callback("");
  }
}

void sendFileToApi(String filePath, String securityToken, Function callback) async {
  var request = await http.MultipartRequest('POST', Uri.parse(_apiIP + "/api/files/upload"));
  request.headers["authorization"] = "Bearer $securityToken";
  request.files.add(
    http.MultipartFile(
      'file',
      File(filePath).readAsBytes().asStream(),
      File(filePath).lengthSync(),
      filename: filePath.split("/").last
    )
  );
  var res = await request.send();
  callback();
}

Future getUsersFilesFromApi(String securityToken) async{
  return http.get(Uri.parse(_apiIP + "/api/files"), headers: {
    "authorization": "Bearer $api_token",
  });
}

Future getDesigns(String securityToken) async {
  return await http.get(Uri.parse(_apiIP + "/api/catalog/designs"), headers: {
    "Authorization": "Bearer $securityToken",
  });
}


Widget getImageFromApi(String imageID, double height, double width, String securityToken, {GlobalKey? key}){
  if(key == null){
    return Image.network(apiIP + "/api/files/" + imageID, width: width, height: height, fit: BoxFit.cover);
  }else{
    return Image.network(apiIP + "/api/files/" + imageID, width: width, height: height, fit: BoxFit.cover, key: key);
  }
}

void likeDesign(String designID, String securityToken, Function callback) async {
  var request = await http.post(Uri.parse(_apiIP + "/api/catalog/design/popularity/" + designID), headers: {
    "Authorization": "Bearer $securityToken",
  });
  if(request.statusCode == 200){
    callback(true);
  }else{
    callback(false);
  }
}

void dislikeDesign(String designID, String securityToken, Function callback) async {
  var request = await http.delete(Uri.parse(_apiIP + "/api/catalog/design/popularity/" + designID), headers: {
    "Authorization": "Bearer $securityToken",
  });
  if(request.statusCode == 200){
    callback(true);
  }else{
    callback(false);
  }
}