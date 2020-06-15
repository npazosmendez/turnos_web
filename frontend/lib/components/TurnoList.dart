import 'dart:html';

import 'package:flutter/material.dart';
import 'package:frontend/utils/TurnoService.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;
import 'TurnoCard.dart';
import 'dart:async';

class TurnoList extends StatefulWidget {
  final model.Usuario usuario;
  final ApiClient apiClient;
  final Map<String,String> filtros;
  final Function(model.Turno) onTap;
  final String mjeSinResultado;

  TurnoList({this.usuario, this.filtros, this.onTap, this.mjeSinResultado}) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  State<StatefulWidget> createState() => _TurnoListState();
}

class _TurnoListState extends State<TurnoList> {

  Future<List<model.Turno>> futureTurnos;

  void _refreshList(Timer t) {
    setState(() {
      futureTurnos = TurnoService(widget.apiClient).query(widget.filtros);
    });
  }

  Timer _timer;
  @override
  void initState() {
    super.initState();
    futureTurnos = TurnoService(widget.apiClient).query(widget.filtros);
    _timer=Timer.periodic(
      new Duration(seconds: 2), _refreshList);
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<model.Turno>>(
        future: futureTurnos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new Expanded(
                  child: ListView(
                      padding: EdgeInsets.all(5),
                      children: snapshot.data.map((t) =>
                          Center(
                            child: TurnoCard(
                              t,
                              TurnoService(widget.apiClient).personasAdelante(t),
                              onDejarPasar: (turno) async {
                                await TurnoService(widget.apiClient).dejarPasar(t);
                                setState(() {
                                  // Forzamos la actualización de todos los turnos
                                  futureTurnos = TurnoService(widget.apiClient).query(widget.filtros);
                                });
                              },
                            )
                          )).toList()
                  )
              );
            } else {
              return Center(child:
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      widget.mjeSinResultado,
                      style: TextStyle(fontSize: 20),
                    )
                ),
              );
            }
          } else if (snapshot.hasError) {
            // TODO
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}