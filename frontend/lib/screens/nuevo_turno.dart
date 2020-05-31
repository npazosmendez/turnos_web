import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';
import '../model.dart' as model;
import '../utils/apiclient.dart';

class NuevoTurno extends StatelessWidget {

  final model.Usuario usuario;
  final ApiClient apiClient;

  NuevoTurno(this.usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Turno")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ConceptoList(
                usuario: usuario,
                header: const Text('Seleccione el concepto para el turno')
            )
          ],
        ),
      ),
    );
  }
}