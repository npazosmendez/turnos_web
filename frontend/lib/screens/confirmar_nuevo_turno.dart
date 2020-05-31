import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;

class ConfirmarNuevoTurno extends StatelessWidget {
  final model.Usuario usuario;
  final model.Concepto concepto;

  const ConfirmarNuevoTurno(this.usuario, this.concepto);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Confirmar Turno"),),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Estas segure que queres un turno para el concepto ${concepto.nombre}?",
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
