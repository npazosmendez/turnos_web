import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/utils/WhatsApp.dart';
import 'package:frontend/utils/apiclient.dart';

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

  void compartirPorWpp() {
    return WhatsappService().compartir(
        ApiClient.getUri("").port.toString(),
        "Te compartieron el turno número "+turno.numero.toString()+
            " para "+turno.concepto.nombre+
            ". Podés ver los detalles en la siguiente URL: ",
        "t+"+turno.uuid+".html"
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      child: Center(
        child: 
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child:
                  Text(
                    "${turno.concepto.nombre.toUpperCase()} (#${turno.numeroToDisplay})",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PersonasAdelante(personasAd),
                      Spacer(),
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
                            onPressed: compartirPorWpp
                          ),
                        ],
                      ),
                    ]
                 )
              ),
            ]
          )
      )
    );
    return card;
  }
}