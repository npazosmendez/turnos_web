import 'package:flutter/material.dart';
import '../model.dart' as model;
import '../utils/apiclient.dart';

class ClientesHome extends StatelessWidget {

  final model.Usuario usuario;
  final ApiClient apiClient;

  ClientesHome(this.usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Turnos")),
      body: Text("Bienvenido, cliente ${this.usuario.email}"),
      );
  }
}