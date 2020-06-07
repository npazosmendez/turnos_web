import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
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

  // TODO: refactor
  Future<http.Response> get(path, {queryParameters}) {
    Map<String, String> headers = {};
    headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    final uri = getUri(path, queryParameters: queryParameters);
    return _client.get(uri, headers: headers);
  }
  Future<http.Response> put(path, {queryParameters}) {
    Map<String, String> headers = {};
    headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    final uri = getUri(path, queryParameters: queryParameters);
    return _client.put(uri, headers: headers);
  }

  Future<http.Response> postJson(String path, Map<String, dynamic> body) {
    Map<String, String> headers = {};
    headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';
    return _client.post(getUri(path), headers: headers, body: jsonEncode(body));
  }

  Future<http.StreamedResponse> postMultipartFile(String path, http.MultipartFile file) {
    var request = new http.MultipartRequest("POST", getUri(path));
    request.headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    request.files.add(file);
    return _client.send(request);
  }
}