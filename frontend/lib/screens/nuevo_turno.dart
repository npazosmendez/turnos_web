import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';
import '../model.dart' as model;
import '../utils/apiclient.dart';
import 'confirmar_nuevo_turno.dart';

class NuevoTurno extends StatelessWidget {

  final model.Usuario usuario;
  final ApiClient apiClient;

  NuevoTurno(this.usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Nuevo Turno")
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Seleccione el concepto para el turno',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
              )
            ),
            ConceptoList(
                usuario: usuario,
                onTap: (concepto) => {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ConfirmarNuevoTurno(this.usuario, concepto)))
                }
            )
          ]
        ),
      ),
    );
  }
}