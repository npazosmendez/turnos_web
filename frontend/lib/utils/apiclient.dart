import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' as Foundation;

class ApiClient {
  
  final http.Client _client = http.Client();
  final String usuario, password;
  
  ApiClient(this.usuario, this.password);

  String _fullUrl(String url) {
    if (Foundation.kDebugMode) {
      return "http://localhost:8080" + url;
    }
    return url;
  }

  Future<http.StreamedResponse> get(String url) {
    var request = new http.Request('GET', Uri.parse(_fullUrl(url)));
    request.headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    return _client.send(request);
  }

  Future<http.StreamedResponse> postJson(String url, Map<String, dynamic> body) {
    var request = new http.Request('POST', Uri.parse(_fullUrl(url)));
    request.headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    request.body = json.encode(body);
    return _client.send(request);
  }

  Future<http.StreamedResponse> postMultipartFile(String url, http.MultipartFile file) {
    var request = new http.MultipartRequest("POST", Uri.parse(_fullUrl(url)));
    request.headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    request.files.add(file);
    return _client.send(request);
  }
}