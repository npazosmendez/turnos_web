import 'package:flutter/material.dart';
import 'login.dart';

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
        onPressed: () {}, // TODO
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