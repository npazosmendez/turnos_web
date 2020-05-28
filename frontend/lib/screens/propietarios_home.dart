import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class PropietariosHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PropietariosHomeState();
}

class _PropietariosHomeState extends State<PropietariosHome> {

  String email = null; // Para saltearse autenticación, asignar un valor acá

  void _signedIn(String email) => setState(() { this.email = email;});

  @override
  Widget build(BuildContext context) {
    if(email == null) {
      // TODO: esto "redirecciona" al login si el estado no tiene un email guardado.
      // Probablemente haya una lógica parecida del lado del cliente. No me queda claro
      // cómo reutilizar este código, creo que heredar States es hacer lío.
      return LoginPage(title: "Propietarios", onSignedIn: _signedIn);
    }else{
      return _build(context);
    }
  }

  Widget _build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Mis Conceptos"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: FormNuevoConcepto(), // TODO
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
                "Bienvenido, ${this.email}.",
              style: TextStyle(
                fontSize: 20.0
                ),
              ),
            ),
            PaginatedDataTable(
              showCheckboxColumn: false,
              header: const Text('Mis Conceptos'),
              columns: <DataColumn>[
                new DataColumn(
                    label: const Text('Nombre'),
                ),
                new DataColumn(
                    label: const Text('En espera'),
                    numeric: true,
                ),
                new DataColumn(
                    label: const Text('Estado'),
                    numeric: true,
                ),
              ],
              source: ConceptosDataSource(this.email),
            ),
          ],
        ),
      ),
    );
  }

}


class ConceptosDataSource extends DataTableSource {

  final String email;

  // TODO: usar this.email para traer los conceptos del tipo
  ConceptosDataSource(this.email);

  @override
  int get rowCount => 2;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    switch (index) {
      case 0:
        return new DataRow.byIndex(
            index: index,
            selected: false,
            onSelectChanged: (bool value) { },
            cells: <DataCell>[
              new DataCell(new Text('Carnicería')),
              new DataCell(new Text("10")),
              new DataCell(Icon(Icons.check, color: Colors.green)),
            ]
        );
        break;
      default:
        return new DataRow.byIndex(
            index: index,
            selected: false,
            onSelectChanged: (bool value) { },
            cells: <DataCell>[
              new DataCell(new Text('Verdulería')),
              new DataCell(new Text("-")),
              new DataCell(Icon(Icons.close, color: Colors.red)),
            ]
        );
        break;
    }
  }
}

// Define a custom Form widget.
class FormNuevoConcepto extends StatefulWidget {
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
            var client = new http.Client();
            var url = "http://localhost:3000/conceptos/";
            var request = new http.Request('POST', Uri.parse(url));
            var body = json.encode({
                "nombre": controllerNombre.text,
                "descripcion": controllerDescripcion.text,
                "latitud": 0,
                "longitud": 0,
            });
            request.headers[HttpHeaders.authorizationHeader] = 'Basic usuario:password'; // TODO
            request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
            request.body = body;
            client.send(request)
              .then(
                (response) => response.stream.bytesToString().then(
                  (value) => print(value.toString()))
              ).catchError((error) => print(error.toString()));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}