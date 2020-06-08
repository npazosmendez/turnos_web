import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model.dart' as model;
import 'package:qr_flutter/qr_flutter.dart';
import '../components/WidgetsTurnos.dart';

class DetalleTurno extends StatelessWidget {
  final model.Turno t;

  DetalleTurno(this.t);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle del turno"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NumeroTurno(t),
            Container(height: 200, width: 200, child: QRTurno(t)),
        ]),
        ))
    ;
  }
}