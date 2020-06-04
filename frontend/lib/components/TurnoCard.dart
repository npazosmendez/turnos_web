import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model.dart' as model;
import 'package:qr_flutter/qr_flutter.dart';

class TurnoCard extends StatelessWidget {
  final model.Turno turno;
  final Function(model.Turno) onTap;

  const TurnoCard(this.turno, {this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[ 
          Expanded( child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(child:
                  Text(
                    'Numero de turno',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  )
                ),
              ),
              Center(child:
                Text(
                  turno.numeroToDisplay.toString(),
                  style: TextStyle(color: Colors.blue, fontSize: 60, fontWeight: FontWeight.bold),
                )
              ),
              Center(child:
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Text(
                    turno.concepto.nombre,
                    style: TextStyle(fontSize: 20),
                  )
                ),
              ),
            ]),
          ),
          QrImage(
            data: turno.numeroToDisplay.toString()+'+'+turno.uuid,
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
          ),
        ]),
      );
    if (onTap != null) {
      return GestureDetector(
        onTap: () => onTap(turno),
        child: card
      );
    }
    return card;
  }
}
