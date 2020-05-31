import 'package:flutter/material.dart';
import '../model.dart' as model;
import '../utils/apiclient.dart';
import 'nuevo_turno.dart';

class ClientesHome extends StatelessWidget {

  final model.Usuario usuario;
  final ApiClient apiClient;

  ClientesHome(this.usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Turnos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NuevoTurno(this.usuario)));
        },
        child: Icon(Icons.add),
        tooltip: "Nuevo Turno",
      ),
      body: Text("Bienvenide, cliente ${this.usuario.email}"),
      );
  }
}