import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoCard.dart';
import 'package:frontend/utils/ConceptoService.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;

class ConceptoList extends StatefulWidget {
  final model.Usuario usuario;
  final ApiClient apiClient;
  final Map<String,String> filtros;
  final Function(model.Concepto) onTap;

  ConceptoList({this.usuario, this.filtros, this.onTap}) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  State<StatefulWidget> createState() => _ConceptoListState();
}

class _ConceptoListState extends State<ConceptoList> {

  Future<List<model.Concepto>> futureConceptos;

  @override
  void initState() {
    super.initState();
    futureConceptos = ConceptoService(widget.apiClient).query(widget.filtros);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<model.Concepto>>(
        future: futureConceptos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Expanded(
              child: ListView(
                padding: EdgeInsets.all(5),
                children: snapshot.data.map((c) => Center(child:ConceptoCard(c, onTap: widget.onTap))).toList()
              )
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