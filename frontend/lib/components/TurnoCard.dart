import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model.dart' as model;
import '../screens/detalle_turno.dart';
import 'error_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TurnoCard extends StatelessWidget {
  final model.Turno turno;
  final Future Function(model.Turno) onDejarPasar;
  // TODO: estaría mejor hacerlo con streams esto. Potencialmente el turno entero?
  final Future<int> personasAdelante;

  const TurnoCard(this.turno, this.personasAdelante, {this.onDejarPasar});

  void tryDejarPasar(context) async {
    try {
      await onDejarPasar(this.turno);
    } catch(err) {
      showErrorDialog(
        context: context,
        error: err,
      );
    }
  }

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
              Tooltip(
                  message: "Mostrá el código QR a tu comerciante amigo",
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetalleTurno(turno))
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 7),
                          child: Icon(Icons.access_time, color: Colors.white),
                        ),
                        Text("Ver código QR", style: TextStyle(color: Colors.white)),
                      ],
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
                          style: TextStyle(color: Colors.black54, fontSize: 40),
                        )
                      ),
                      Center(
                        child: Icon(Icons.people, size: 35),
                      ),
                      Tooltip(
                        message: "Dejá pasar a quien esté detrás tuyo",
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () => this.tryDejarPasar(context),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 7),
                                child: Icon(Icons.access_time, color: Colors.white),
                              ),
                              Text("ESTOY ATRASADO", style: TextStyle(color: Colors.white)),
                            ],
                          )
                        ),
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
    return card;
  }
}
