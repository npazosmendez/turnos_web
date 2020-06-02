import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';
import 'package:frontend/utils/ConceptoService.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;
import 'detalle_concepto.dart';

class PropietariosHome extends StatelessWidget {
  static const String routeName = '/propietarios';

  @override
  Widget build(BuildContext context) {
    final model.Usuario usuario = ModalRoute.of(context).settings.arguments;

    return new Scaffold(
      appBar: AppBar(title: Text("Mis Conceptos"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: FormNuevoConcepto(usuario), // TODO
              );
            }, // TODO
          );
        },
        child: Icon(Icons.add),
        tooltip: "Nuevo concepto",
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Bienvenido, ${usuario.email}.",
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
            ),
            ConceptoList(
              usuario: usuario,
              filtros: {"usuarioId": usuario.id.toString()},
              onTap: (concepto) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetalleConcepto(usuario, concepto.id))
                );
              }
            )
          ],
        ),
      ),
    );
  }
}

// Define a custom Form widget.
class FormNuevoConcepto extends StatefulWidget {
  final ApiClient apiClient;
  final model.Usuario usuario;

  FormNuevoConcepto(this.usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  _FormNuevoConceptoState createState() => _FormNuevoConceptoState();
}

class _FormNuevoConceptoState extends State<FormNuevoConcepto> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final controllerNombre = TextEditingController();
  final controllerDescripcion = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerNombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controllerNombre,
          decoration: InputDecoration(
            hintText: 'Nombre'
          ),
        ),
        TextField(
          controller: controllerDescripcion,
          decoration: InputDecoration(
            hintText: 'Descripción'
          ),
        ),
        RaisedButton(
          child: Text("Submit"),
          onPressed: () async {
            try {
              ConceptoService(widget.apiClient).create(
                controllerNombre.text,
                controllerDescripcion.text
              );
            } catch (ex) {
              // TODO: handle
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}