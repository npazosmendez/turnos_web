import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model.dart' as model;
import '../screens/detalle_turno.dart';
import 'error_dialog.dart';
import '../components/WidgetsTurnos.dart';

class TurnoCard extends StatelessWidget {
  final model.Turno turno;
  final Future Function(model.Turno) onDejarPasar;
  // TODO: estaría mejor hacerlo con streams esto. Potencialmente el turno entero?
  final Future<int> personasAd;

  const TurnoCard(this.turno, this.personasAd, {this.onDejarPasar});

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[ 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumeroTurno(turno),
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
                    child: Text("Ver código QR", style: TextStyle(color: Colors.white)),
                  ),
                ),
            ]
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PersonasAdelante(personasAd),
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
            ]
          ),
        ]));
    return card;
  }
}
