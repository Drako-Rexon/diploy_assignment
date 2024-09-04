import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart";
// import "package:package_info_plus/package_info_plus.dart";

Future<Map<String, String>> getHeaders(String? token) async {
  WidgetsFlutterBinding.ensureInitialized();
  // PackageInfo packageInfo = await PackageInfo.fromPlatform();

  var headers = {
    "Device-OS": Platform.operatingSystem,
    // "Build-Number": packageInfo.buildNumber.toString(),
    "content-type": "application/json"
  };

  if (token != null) {
    headers["Authorization"] = "Bearer $token";
  }

  return headers;
}

Future<Response> request(
  String method,
  String path, {
  String? token,
  Map<String, dynamic>? params,
  Map? json,
  Encoding? encoding,
}) async {
  final String baseUrl = dotenv.env['BASE_URL'] ?? "";
  final url = Uri.https(baseUrl, path, params);
  final body = jsonEncode(json);
  late Response response;
  log('api hit: $url');

  switch (method.toUpperCase()) {
    case "GET":
      response = await get(url, headers: await getHeaders(token));
      break;
    case "POST":
      response = await post(url,
          headers: await getHeaders(token), body: body, encoding: encoding);
      break;
    case "PUT":
      response = await put(url,
          headers: await getHeaders(token), body: body, encoding: encoding);
      break;
    case "PATCH":
      response = await patch(url,
          headers: await getHeaders(token), body: body, encoding: encoding);
      break;
    case "DELETE":
      response = await delete(url,
          headers: await getHeaders(token), body: body, encoding: encoding);
      break;
    default:
      throw Exception("Invalid method!");
  }
  return response;
}

Map<String, dynamic> res(Response response) {
  return {
    "status": response.statusCode,
    "data": jsonDecode(response.body),
  };
}
