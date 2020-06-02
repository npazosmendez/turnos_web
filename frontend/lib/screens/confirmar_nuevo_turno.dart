import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoCard.dart';

import '../model.dart' as model;

class ConfirmarNuevoTurno extends StatelessWidget {
  final model.Usuario usuario;
  final model.Concepto concepto;

  const ConfirmarNuevoTurno(this.usuario, this.concepto);

  confirmarTurno() {

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Confirmar Turno"),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConceptoCard(concepto),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
                child: Container(
                constraints: BoxConstraints(
                    maxWidth: 400
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: confirmarTurno,
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Text('CONFIRMAR'),
                  ),
                )
              )
            )
          ]
        )
      )
    );
  }
}
