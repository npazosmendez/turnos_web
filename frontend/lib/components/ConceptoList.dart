import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoCard.dart';
import 'dart:convert';

import '../utils/apiclient.dart';
import '../model.dart' as model;

class ConceptoList extends StatefulWidget {
  final model.Usuario usuario;
  final ApiClient apiClient;
  final Widget header;
  final Map<String,String> filtros;
  final Function(model.Concepto) onTap;

  ConceptoList({this.usuario, this.header, this.filtros, this.onTap}) : this.apiClient = ApiClient(usuario.email, usuario.password);

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