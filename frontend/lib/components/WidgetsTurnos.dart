import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utils/apiclient.dart';

import '../model.dart' as model;
import 'package:qr_flutter/qr_flutter.dart';

class TurnoQrDialog extends StatelessWidget {
  final model.Turno t;

  TurnoQrDialog(this.t);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${t.concepto.nombre.toUpperCase()} (#${t.numeroToDisplay})",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Container(height: 200, width: 200, child: QRTurno(t)),
        ],
      ),
    );
  }
}

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

class QRTurno extends StatelessWidget {
  final model.Turno t;
  QRTurno(this.t);

  @override
  Widget build(BuildContext context){
    return QrImage(
      //data: t.numeroToDisplay.toString()+'+'+t.uuid,
      data: t.uuid,
      version: QrVersions.auto,
      backgroundColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );
  }
}

class BotonConIcono extends StatelessWidget {
  final Widget icon;
  final String text;
  final String tooltip;
  final Function onPressed;
  BotonConIcono({this.icon, this.text, this.tooltip, this.onPressed});

  @override
  Widget build(BuildContext context){
    return Tooltip(
      message: tooltip,
      child: ButtonTheme(
        minWidth: 180.0,
        child: RaisedButton(
          color: Colors.blue,
          onPressed:onPressed,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 7),
                child: icon,
              ),
              Text(text, style: TextStyle(color: Colors.white)),
            ],
          )
        ),
      ),
    );
  }
}