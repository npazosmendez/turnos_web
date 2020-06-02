import 'package:flutter/material.dart';
import 'package:frontend/utils/TurnoService.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;
import 'TurnoCard.dart';

class TurnoList extends StatefulWidget {
  final model.Usuario usuario;
  final ApiClient apiClient;
  final Map<String,String> filtros;
  final Function(model.Turno) onTap;

  TurnoList({this.usuario, this.filtros, this.onTap}) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  State<StatefulWidget> createState() => _TurnoListState();
}

class _TurnoListState extends State<TurnoList> {

  Future<List<model.Turno>> futureTurnos;

  @override
  void initState() {
    super.initState();
    futureTurnos = TurnoService(widget.apiClient).query(widget.filtros);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<model.Turno>>(
        future: futureTurnos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Expanded(
                child: ListView(
                    padding: EdgeInsets.all(5),
                    children: snapshot.data.map((t) => Center(child:TurnoCard(t))).toList()
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