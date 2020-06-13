import 'dart:convert';
import 'package:frontend/utils/apiclient.dart';

import '../model.dart';

class UsuarioService {
  static Future<Usuario> login(email, password) async {
    ApiClient apiClient = ApiClient(email, password);
    var response = await apiClient.get("/usuarios/login");
    if(response.statusCode == 200) {
      var usuarioJson = json.decode(response.body);
      return Usuario.fromJson(usuarioJson);
    }
    return Future.error(response.statusCode.toString());
  }

  static Future<Usuario> register(nombre, apellido, email, password) async {
    ApiClient apiClient = ApiClient(null, null);
    var response = await apiClient.postJson("/usuarios/", {
      "email": email,
      "password": password,
      "nombre": nombre,
      "apellido": apellido
    });
    if(response.statusCode == 201){
      return Usuario.fromJson(json.decode(response.body));
    }
    return Future.error(response.body);
  }
}