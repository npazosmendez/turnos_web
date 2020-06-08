import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model.dart' as model;
import 'package:qr_flutter/qr_flutter.dart';

class TurnoCard extends StatelessWidget {
  final model.Turno turno;
  final Function(model.Turno) onTap;
  // TODO: estaría mejor hacerlo con streams esto. Potencialmente el turno entero?
  final Future<int> personasAdelante;

  const TurnoCard(this.turno, this.personasAdelante, {this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      child: Row(
        children: <Widget>[ 
          Expanded( child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(child:
                  Text(
                    'Número de turno',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: FutureBuilder<int>(
              future: this.personasAdelante,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Center(child:
                          Text(
                            'Personas adelante',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          )
                        ),
                      ),
                      Center(child:
                        Text(
                          snapshot.data.toString(),
                          style: TextStyle(color: Colors.black54, fontSize: 60),
                        )
                      ),
                      Center(
                        child: Icon(Icons.people, size: 35),
                      ),
                    ]);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
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
