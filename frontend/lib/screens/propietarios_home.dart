import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';
import 'package:frontend/utils/ConceptoService.dart';
import 'package:flutter/services.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;
import 'detalle_concepto.dart';

class PropietariosHome extends StatelessWidget {
  static const String routeName = '/propietarios';
  final model.Usuario usuario;

  PropietariosHome(this.usuario);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Mis Conceptos"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result=await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: FormNuevoConcepto(usuario), // TODO
              );
            }, // TODO
          );
          if (result!=null){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => PropietariosHome(usuario)));
          }
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
                "Bienvenide, ${usuario.email}!",
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
            ),
            ConceptoList(
              usuario: usuario,
              filtros: {"usuarioId": usuario.id.toString()},
              onTap: (concepto) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetalleConcepto(usuario, concepto.id))
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => PropietariosHome(usuario)));
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
  final controllerMaximaEspera = TextEditingController();

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
            labelText: 'Nombre'
          ),
        ),
        TextField(
          controller: controllerDescripcion,
          decoration: InputDecoration(
            labelText: 'Descripción'
          ),
        ),
        new TextField(
          controller: controllerMaximaEspera,
          decoration: new InputDecoration(labelText: "Máxima espera (opcional)"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        ),
        RaisedButton(
          child: Text("Submit"),
          onPressed: () async {
            try {
              ConceptoService(widget.apiClient).create(
                controllerNombre.text,
                controllerDescripcion.text,
                int.tryParse(controllerMaximaEspera.text),
              );
            } catch (ex) {
              // TODO: handle
            }
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}