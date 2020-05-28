import 'package:flutter/material.dart';

import 'login.dart';
import '../utils/apiclient.dart';

class PropietariosHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PropietariosHomeState();
}

class _PropietariosHomeState extends State<PropietariosHome> {

  String usuario, password;
  ApiClient apiClient;

  void _signedIn(String usuario, String password) => setState(
    () {
      this.usuario = usuario;
      this.password = password;
      this.apiClient = ApiClient(usuario, password);
    }
  );

  @override
  Widget build(BuildContext context) {
    if(usuario == null) {
      // TODO: esto "redirecciona" al login si el estado no tiene un usuario guardado.
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
                content: FormNuevoConcepto(this.apiClient), // TODO
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
                "Bienvenido, ${this.usuario}.",
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
              source: ConceptosDataSource(this.usuario),
            ),
          ],
        ),
      ),
    );
  }

}


class ConceptosDataSource extends DataTableSource {

  final String usuario;

  // TODO: usar this.usuario para traer los conceptos del tipo
  ConceptosDataSource(this.usuario);

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
  final ApiClient apiClient;

  FormNuevoConcepto(this.apiClient);

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
                "http://localhost:3000/conceptos/",
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