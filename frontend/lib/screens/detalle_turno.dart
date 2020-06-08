import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model.dart' as model;
import 'package:qr_flutter/qr_flutter.dart';

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
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NumeroTurno(t),
            Container(height: 200, width: 200, child: QRTurno(t)),
        ]),
        ))
    ;
  }
}

class NumeroTurno extends StatelessWidget {
  final model.Turno t;
  NumeroTurno(this.t);

  @override
  Widget build(BuildContext context){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Número de turno',style: TextStyle(color: Colors.grey, fontSize: 14),),
        Text(t.numeroToDisplay.toString(),style: TextStyle(color: Colors.blue, fontSize: 60, fontWeight: FontWeight.bold)),
        Text(t.concepto.nombre,style: TextStyle(fontSize: 20)),
      ]
    );
  }
}

class QRTurno extends StatelessWidget {
  final model.Turno t;
  QRTurno(this.t);

  @override
  Widget build(BuildContext context){
    return QrImage(
      data: t.numeroToDisplay.toString()+'+'+t.uuid,
      version: QrVersions.auto,
      backgroundColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );
  }
}