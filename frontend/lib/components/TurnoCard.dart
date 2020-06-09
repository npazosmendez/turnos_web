import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model.dart' as model;
import 'error_dialog.dart';
import '../components/WidgetsTurnos.dart';
import 'dart:js' as js;

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
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "${turno.concepto.nombre.toUpperCase()} (#${turno.numeroToDisplay})",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                     padding: EdgeInsets.fromLTRB(0, 0, 100, 0),
                     child: 
                      PersonasAdelante(personasAd),
                  ),
                  Column(
                    children: [
                      BotonConIcono(
                        icon: Icon(Icons.access_time, color: Colors.white),
                        text: "ESTOY ATRASADO",
                        tooltip: "Dejá pasar a quien esté detrás tuyo",
                        onPressed: () => this.tryDejarPasar(context),
                      ),
                      BotonConIcono(
                        icon: FaIcon(FontAwesomeIcons.qrcode, color: Colors.white),
                        text: "CÓDIGO QR",
                        tooltip: "Mostrá el código QR a tu comerciante amigo",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TurnoQrDialog(turno),
                          );
                        },
                      ),
                      BotonConIcono(
                        icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                        text: "COMPARTIR",
                        tooltip: "Compartí el turno por Whatsapp",
                        onPressed: () { js.context.callMethod("whatsapp"); },
                      ),
                    ],
                  ),
                ],
              )
            ),
          ],
        ),
      )
    );
    return card;
  }
}
