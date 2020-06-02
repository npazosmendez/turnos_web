import 'package:flutter/material.dart';
import '../model.dart' as model;
import 'nuevo_turno.dart';

class ClientesHome extends StatelessWidget {
  static const String routeName = '/clientes';

  @override
  Widget build(BuildContext context) {
    final model.Usuario usuario = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text("Mis Turnos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NuevoTurno(usuario)));
        },
        child: Icon(Icons.add),
        tooltip: "Nuevo Turno",
      ),
      body: Text("Bienvenide, cliente ${usuario.email}"),
      );
  }
}