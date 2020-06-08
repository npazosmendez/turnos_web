import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utils/apiclient.dart';

import '../model.dart' as model;
import '../screens/detalle_turno.dart';
import '../utils/TurnoService.dart';
import 'error_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PersonasAdelante extends StatelessWidget {
  final Future<int> futurePa;
  PersonasAdelante(this.futurePa);
  
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: futurePa,
      builder: (context, resultado) {
        if (resultado.hasData){
          return  Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Personas adelante',style: TextStyle(color: Colors.grey, fontSize: 14),),
                        Text(resultado.data.toString(),style: TextStyle(color: Colors.black54, fontSize: 60)),                     
                        Icon(Icons.people, size: 35),
                      ]
                    )
                  );
        } else {
          if (resultado.hasError){
            return Text('Hubo un error');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }
}

class NumeroTurno extends StatelessWidget {
  final model.Turno t;
  NumeroTurno(this.t);

  @override
  Widget build(BuildContext context){
    return Container(
      height: 120,
      child:
        Column(mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Número de turno',style: TextStyle(color: Colors.grey, fontSize: 14),),
            Text(t.numeroToDisplay.toString(),style: TextStyle(color: Colors.blue, fontSize: 60, fontWeight: FontWeight.bold)),
            Text(t.concepto.nombre,style: TextStyle(fontSize: 20)),
          ]
        )
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