import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;

class PropietariosHome extends StatelessWidget {
  final model.Usuario usuario;

  const PropietariosHome(this.usuario);

  @override
  Widget build(BuildContext context) {
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
                header: const Text('Mis Conceptos'),
                filtros: {"usuarioId": usuario.id.toString()},
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

  FormNuevoConcepto(usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

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
              var response = await this.widget.apiClient.postJson(
                "/conceptos/",
                {
                  "nombre": controllerNombre.text,
                  "descripcion": controllerDescripcion.text,
                  "latitud": 0,
                  "longitud": 0,
                }
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