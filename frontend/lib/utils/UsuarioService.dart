import 'dart:convert';
import 'package:frontend/utils/apiclient.dart';

import '../model.dart';

class UsuarioService {
  static Future<Usuario> login(email, password) async {
    ApiClient apiClient = ApiClient(email, password);
    var response = await apiClient.get("/usuarios/login");

    var usuarioJson = json.decode(response.body);
    return Usuario.fromJson(usuarioJson);
  }
}