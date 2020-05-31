import 'package:flutter/material.dart';
import 'dart:convert';

import '../utils/apiclient.dart';
import '../model.dart' as model;

class ConceptoList extends StatefulWidget {
  final model.Usuario usuario;
  final ApiClient apiClient;
  final Widget header;
  final Map<String,String> filtros;

  ConceptoList({this.usuario, this.header, this.filtros}) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  State<StatefulWidget> createState() => _ConceptoListState();
}

class _ConceptoListState extends State<ConceptoList> {

  Future<List<model.Concepto>> futureConceptos;

  @override
  void initState() {
    super.initState();
    futureConceptos = fetchConceptos();
  }

  Future<List<model.Concepto>> fetchConceptos() async {
    var response = await widget.apiClient.get("/conceptos", queryParameters: widget.filtros);

    Iterable conceptosJson = json.decode(response.body);
    return List<model.Concepto>.from(
        conceptosJson.map((json) => model.Concepto.fromJson(json))
    );
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<model.Concepto>>(
        future: futureConceptos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PaginatedDataTable(
              showCheckboxColumn: false,
              header: widget.header,
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