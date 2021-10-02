import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class NetworkService {
  static String? token = "";
  static String? refreshToken = "";

  // static const BASE_URL = "http://62.151.183.194:5151/api/v1/";
  // static const WS_URL = "ws://192.168.1.11:8000/";

  // static const BASE_URL = "http://134.209.36.121:8989/api/v1/";
  // static const WS_URL = "ws://134.209.36.121:8989/websocket/";

  static const BASE_URL = "https://indomi.app/api/v1/";
  static const WS_URL = "ws://indomi.app/";

  static Future<String> getToken() async {
    if (token == "" || token == null) {
      final storage = new FlutterSecureStorage();
      token = await storage.read(key: "token");
      return token ?? "";
    } else {
      return token ?? "";
    }
  }

  static Future<String> getRefreshToken() async {
    if (refreshToken == "" || refreshToken == null) {
      final storage = new FlutterSecureStorage();
      refreshToken = await storage.read(key: "refresh");
      return refreshToken ?? "";
    } else {
      return refreshToken ?? "";
    }
  }

  static Future<void> setToken(String newToken) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "token", value: newToken);
    token = newToken;
  }

  static getHeaders(bool auth, {bool multipart = false}) async {
    return auth
        ? {
            "Authorization": "Bearer " + await getToken(),
            "Content-Type":
                !multipart ? "application/json" : "multipart/form-data"
          }
        : {
            "Content-Type":
                !multipart ? "application/json" : "multipart/form-data"
          };
  }

  static Future<dynamic> get(String path,
      {bool auth = true, bool base = true}) async {
    try {
      final response = await http.get(Uri.parse((base ? BASE_URL : "") + path),
          headers: await getHeaders(auth));
      return getResponse(response);
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> simpleGet(String path, {bool auth = true}) async {
    try {
      final response =
          await http.get(Uri.parse(path), headers: await getHeaders(auth));
      return getResponse(response);
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body,
      {bool auth = true}) async {
    try {
      final response = await http.post(Uri.parse(BASE_URL + path),
          body: json.encode(body), headers: await getHeaders(auth));
      return getResponse(response);
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error({"message": e.toString()});
    }
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body,
      {bool auth = true}) async {
    try {
      final response = await http.put(Uri.parse(BASE_URL + path),
          body: json.encode(body), headers: await getHeaders(auth));
      return getResponse(response);
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error({"message": e.toString()});
    }
  }

  static Future<dynamic> delete(String path, {bool auth = true}) async {
    try {
      final response = await http.delete(Uri.parse(BASE_URL + path),
          headers: await getHeaders(auth));
      return getResponse(response);
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error({"message": e.toString()});
    }
  }

  static Future<dynamic> postMultipart(
      url, Map<String, String> body, File image,
      {bool auth = true}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      if (body != null) {
        request.fields.addAll(body);
      }
      if (image != null) {
        //      final mimeTypeData =
//          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
        final file = await http.MultipartFile.fromPath('file', image.path);
        await image.length();
//      request.fields['ext'] = mimeTypeData[1];
        request.files.add(file);
      }
      if (auth) {
        request.headers.addAll(await getHeaders(auth, multipart: true));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode < 400) {
        return {"success": true, "upload": true};
      } else {
        return Future.error({"error": "No se ha podido subir el archivo"});
      }
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error({"message": e.toString()});
    }
  }

  static Future<dynamic> simplePutS3(url, List<int> imageData) async {
    try {
      final response = await http.put(url, body: imageData);
      return getResponse(response);
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error({"message": e.toString()});
    }
  }

  static Future<dynamic> putMultipartS3(
      url, body, String filename, List<int> imageData,
      {bool auth = true}) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      if (body != null) {
        request.fields.addAll(body);
      }
      if (imageData != null) {
        final file = http.MultipartFile.fromBytes('picture', imageData,
            filename: filename, contentType: MediaType("image", "jpg"));
        request.files.add(file);
      }
      if (auth) {
        request.headers.addAll(await getHeaders(auth, multipart: true));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return getResponse(response);
    } on SocketException {
      return Future.error(
          {"message": "No se ha podido establecer conexion con el servidor"});
    } catch (e) {
      return Future.error({"message": e.toString()});
    }
  }

  static dynamic getResponse(http.Response response) {

    print(response.statusCode);
    if (response.body.isEmpty &&
        response.statusCode >= 200 &&
        response.statusCode < 300) {
      return {"message": "", "code": response.statusCode};
    }

    if (response.body.isEmpty && response.statusCode >= 400) {
      return Future.error(
          {"message": "Se ha producido un error", "code": response.statusCode});
    }
    final decodedJson = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedJson;
    }

    if (response.statusCode >= 400) {
      return Future.error(decodedJson);
    }

    // switch (response.statusCode) {
    //   case 200:
    //     return decodedJson;
    //   case 201:
    //     return decodedJson;
    //   case 400:
    //     return Future.error(decodedJson);
    //   case 401:
    //     return Future.error(decodedJson);
    // }
  }
}
