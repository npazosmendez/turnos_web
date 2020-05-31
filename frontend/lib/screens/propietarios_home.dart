import 'package:flutter/material.dart';
import 'dart:convert';

import '../utils/apiclient.dart';
import '../model.dart' as model;

class PropietariosHome extends StatefulWidget {
  final model.Usuario usuario;
  final ApiClient apiClient;

  PropietariosHome(this.usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  State<StatefulWidget> createState() => _PropietariosHomeState();
}

class _PropietariosHomeState extends State<PropietariosHome> {

  Future<List<model.Concepto>> futureConceptos;

  @override
  void initState() {
    super.initState();
    futureConceptos = fetchConceptos();
  }

  Future<List<model.Concepto>> fetchConceptos() async {
    var apiClient = ApiClient(widget.usuario.email, widget.usuario.password);
    var response = await apiClient.get("/conceptos?usuarioId=${widget.usuario.id}");

    Iterable conceptosJson = json.decode(response.body);
    return List<model.Concepto>.from(
        conceptosJson.map((json) => model.Concepto.fromJson(json))
    );
  }

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
                content: FormNuevoConcepto(this.widget.apiClient), // TODO
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
                "Bienvenido, ${this.widget.usuario.email}.",
              style: TextStyle(
                fontSize: 20.0
                ),
              ),
            ),
            FutureBuilder<List<model.Concepto>>(
              future: futureConceptos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PaginatedDataTable(
                    showCheckboxColumn: false,
                    header: const Text('Mis Conceptos'),
                    columns: <DataColumn>[
                      new DataColumn(
                        label: const Text('Nombre'),
                      ),
                      new DataColumn(
                        label: const Text('Descripción'),
                      ),
                      new DataColumn(
                        label: const Text('Estado'),
                        numeric: true,
                      ),
                    ],
                    source: ConceptosDataSource(snapshot.data),
                  );
                } else if (snapshot.hasError) {
                  // TODO
                }
                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            )
          ],
        ),
      ),
    );
  }

}


class ConceptosDataSource extends DataTableSource {

  final List<model.Concepto> conceptos;

  ConceptosDataSource(this.conceptos);

  @override
  int get rowCount => this.conceptos.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    var concepto = this.conceptos[index];
    return new DataRow.byIndex(
        index: index,
        selected: false,
        onSelectChanged: (bool value) { },
        cells: <DataCell>[
          new DataCell(new Text(concepto.nombre)),
          new DataCell(new Text(concepto.descripcion)),
          new DataCell(concepto.habilitado
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.close, color: Colors.red)),
        ]
    );
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