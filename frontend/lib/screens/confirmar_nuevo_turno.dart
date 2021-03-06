import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoCard.dart';
import 'package:frontend/components/error_dialog.dart';
import 'package:frontend/utils/TurnoService.dart';
import 'package:frontend/utils/apiclient.dart';
import 'package:frontend/screens/home.dart';

import '../model.dart' as model;
import 'clientes_home.dart';

class ConfirmarNuevoTurno extends StatelessWidget {
  final model.Usuario usuario;
  final model.Concepto concepto;
  final ApiClient apiClient;

  ConfirmarNuevoTurno(this.usuario, this.concepto): this.apiClient = ApiClient(usuario.email, usuario.password);

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
                    onPressed: () async {
                      try {
                        await TurnoService(apiClient).create(concepto);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ClientesHome.routeName,
                          ModalRoute.withName('/home'),
                        );
                      } catch (err) {
                        showErrorDialog(
                          context: context,
                          error: err,
                        );
                      }
                    },
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
