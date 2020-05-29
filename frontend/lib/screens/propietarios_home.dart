import 'package:flutter/material.dart';
import 'dart:convert';

import 'login.dart';
import '../utils/apiclient.dart';
import '../model.dart' as model;

class PropietariosHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PropietariosHomeState();
}

class _PropietariosHomeState extends State<PropietariosHome> {

  model.Usuario usuario;
  ApiClient apiClient;
  List<model.Concepto> conceptos = [];
  /* TODO: flutter llama a build muchas veces, y la app usa la API en el build.
  Este bool es para no llamar a la API para obtener la info cada vez que se buildea.
  Estaría bueno, en vez de esto, tener un timestamp de cuándo se actualizó y actualizarlo
  cada cierto periodo.
  */
  bool calledApi = false;

  loadConceptos() async {
    var apiClient = ApiClient(usuario.email, usuario.password);
    var response = await apiClient.get(
      "http://localhost:3000/conceptos?usuarioId=${usuario.id}", // TODO: tomar por config
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

  void _signedIn(model.Usuario usuario) => setState(
    () {
      this.usuario = usuario;
      this.apiClient = ApiClient(usuario.email, usuario.password);
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
    if(!this.calledApi) loadConceptos();

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
                "Bienvenido, ${this.usuario.email}.",
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