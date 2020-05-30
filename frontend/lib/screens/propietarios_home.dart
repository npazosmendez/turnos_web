import 'package:flutter/material.dart';
import 'dart:convert';

import 'login.dart';
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

  List<model.Concepto> conceptos = [];
  /* TODO: flutter me está llamando build muchas veces, no estoy seguro por qué.
  Este bool es para no llamar a la API para obtener la info cada vez que se buildea.
  */
  bool calledApi = false;


  loadConceptos() async {
    var apiClient = ApiClient(widget.usuario.email, widget.usuario.password);
    var response = await apiClient.get(
      "/conceptos?usuarioId=${widget.usuario.id}", // TODO: tomar por config
    );
    var body = await response.stream.bytesToString();
    Iterable conceptosJson = json.decode(body);
    List<model.Concepto> conceptos = [];
    for (var json in conceptosJson) {
      conceptos.add(model.Concepto.fromJson(json));
    }
    this.calledApi = true;
    setState( () => this.conceptos = conceptos);
  }

  @override
  Widget build(BuildContext context) {
    if(!this.calledApi) loadConceptos();

    return new Scaffold(
      appBar: AppBar(title: Text("Mis Conceptos"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: FormNuevoConcepto(this.widget.apiClient, this.widget.usuario), // TODO
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
            PaginatedDataTable(
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
              source: ConceptosDataSource(this.conceptos),
            ),
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
  final model.Usuario usuario;

  FormNuevoConcepto(this.apiClient, this.usuario);

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
                  "usuarioId": widget.usuario.id,
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