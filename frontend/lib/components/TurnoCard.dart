import 'package:flutter/material.dart';

import '../model.dart' as model;

class TurnoCard extends StatelessWidget {
  final model.Turno turno;
  final Function(model.Turno) onTap;

  const TurnoCard(this.turno, {this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      constraints: BoxConstraints(
          maxWidth: 300
      ),
      child:Card(
        child: Column(
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
            )
          ],
        ),
      )
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
