import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';

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

Future resetPassword(String securityToken, String password) async {
  print(securityToken);
  var result =  await http.post(
    Uri.parse(_apiIP + "/api/user/resetPassword"),
    headers: {
      "password": password,
      "Authorization": "Bearer $securityToken",
    },
  );
  if(result.statusCode == 200){
    return true;
  }else{
    return false;
  }
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

void sendFileToApi(String filePath, String securityToken, Function callback, {bool returnToken = false}) async {
  var request = await http.MultipartRequest('POST', Uri.parse(_apiIP + "/api/files/upload"));
  request.headers["authorization"] = "Bearer $securityToken";
  request.files.add(
    http.MultipartFile(
      'file',
      io.File(filePath).readAsBytes().asStream(),
      io.File(filePath).lengthSync(),
      filename: filePath.split("/").last
    )
  );
  var response = await request.send();
  if(returnToken){
    callback(await response.stream.bytesToString());
  }else{
    callback();
  }
}

Future sendDesignToApi({required Map<String, String> headers, required Map<String, dynamic> designBody, required String securityToken}) async {
  headers["Authorization"] = "Bearer $securityToken";
  headers["content-type"] = "application/json";
  var request = await http.post(Uri.parse(_apiIP + "/api/catalog/designs"), headers: headers, body: jsonEncode(<String, dynamic>{"properties": designBody}));
  if(request.statusCode == 200){
    return true;
  }else{
    return false;
  }
}

Future getUsersFilesFromApi(String securityToken) async{
  return await http.get(Uri.parse(_apiIP + "/api/files"), headers: {
    "Authorization": "Bearer $securityToken",
  });
}

Future getDesigns(String securityToken) async {
  return await http.get(Uri.parse(_apiIP + "/api/catalog/designs"), headers: {
    "Authorization": "Bearer $securityToken",
  });
}

Future getDesign(String designID, String securityToken) async {
  if(designID != ""){
    return await http.get(Uri.parse(_apiIP + "/api/catalog/designs/" + designID), headers: {
      "Authorization": "Bearer $securityToken",
    });
  }
}


Widget getImageFromApi(String imageID, String securityToken, {GlobalKey? key, double height = 0, double width = 0}){
  if(height != 0){
    if(width != 0){
      if(key == null){
        return Image.network(apiIP + "/api/files/" + imageID, width: width, height: height, fit: BoxFit.cover);
      }else{
        return Image.network(apiIP + "/api/files/" + imageID, width: width, height: height, fit: BoxFit.cover, key: key);
      }
    }else{
      if(key == null){
        return Image.network(apiIP + "/api/files/" + imageID, height: height, fit: BoxFit.cover);
      }else{
        return Image.network(apiIP + "/api/files/" + imageID, height: height, fit: BoxFit.cover, key: key);
      }
    }
  }else{
    if(width != 0){
      if(key == null){
        return Image.network(apiIP + "/api/files/" + imageID, width: width, fit: BoxFit.cover);
      }else{
        return Image.network(apiIP + "/api/files/" + imageID, width: width, fit: BoxFit.cover, key: key);
      }
    }else{
      if(key == null){
        return Image.network(apiIP + "/api/files/" + imageID, fit: BoxFit.cover);
      }else{
        return Image.network(apiIP + "/api/files/" + imageID, fit: BoxFit.cover, key: key);
      }
    }
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
  print("$designID");
  var request = await http.delete(Uri.parse(_apiIP + "/api/catalog/design/popularity/" + designID), headers: {
    "Authorization": "Bearer $securityToken",
  });
  if(request.statusCode == 200){
    callback(true);
  }else{
    print(request.statusCode);
    print(request.body);
    callback(false);
  }
}

Future getUsername(String securityToken, {Function? callback}) async {
  if(callback == null){
    var request = await http.get(Uri.parse(_apiIP + "/api/user"), headers: {
      "Authorization": "Bearer $securityToken",
    });
    if(request.statusCode == 200){
      return request.body;
    }else{
      return null;
    }
  }else{
    var request = await http.get(Uri.parse(_apiIP + "/api/user"), headers: {
      "Authorization": "Bearer $securityToken",
    });
    if(request.statusCode == 200){
      callback(request.body);
    }else{
      callback(null);
    }
  }

}
void logout(String securityToken) async {
  await http.post(Uri.parse(_apiIP + "/api/user/logout"), headers: {
    "Authorization": "Bearer $securityToken",
  });
}