import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' as Foundation;

class ApiClient {
  
  final http.Client _client = http.Client();
  final String usuario, password;
  
  ApiClient(this.usuario, this.password);

  Uri _getUri(String path, Map<String, dynamic> queryParameters) {
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

  String _fullUrl(String url) {
//   TODO: remove this method and use getUri
    if (Foundation.kDebugMode) {
      return "http://localhost:3000" + url;
    }
    return url;
  }

  Future<http.Response> get(path, {queryParameters}) {
    Map<String, String> headers = {};
    headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    final uri = _getUri(path, queryParameters);

    return _client.get(uri, headers: headers);
  }

  Future<http.StreamedResponse> postJson(String url, Map<String, dynamic> body) {
    var request = new http.Request('POST', Uri.parse(_fullUrl(url)));
    request.headers[HttpHeaders.authorizationHeader] = 'Basic ${this.usuario}:${this.password}';
    request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    request.body = json.encode(body);
    return _client.send(request);
  }

}