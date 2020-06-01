import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' as Foundation;

class ApiClient {
  
  final http.Client _client = http.Client();
  final String usuario, password;
  
  ApiClient(this.usuario, this.password);

  static Uri getUri(String path, {Map<String, String> queryParameters}) {
    if (Foundation.kDebugMode) {
      return Uri(
          host: 'localhost',
          port: 3000,
          path: path,
          queryParameters:queryParameters
      );
    }
    return Uri(
        path: path,
        queryParameters:queryParameters
    );
  }

  Future<http.Response> get(path, {queryParameters}) {
    Map<String, String> headers = {};
    headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    final uri = getUri(path, queryParameters: queryParameters);
    return _client.get(uri, headers: headers);
  }

  Future<http.StreamedResponse> postJson(String path, Map<String, dynamic> body) {
    var request = new http.Request('POST', getUri(path));
    request.headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    request.body = json.encode(body);
    return _client.send(request);
  }

  Future<http.StreamedResponse> postMultipartFile(String path, http.MultipartFile file) {
    var request = new http.MultipartRequest("POST", getUri(path));
    request.headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    request.files.add(file);
    return _client.send(request);
  }
}