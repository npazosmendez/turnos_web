import 'package:flutter/material.dart';
import 'package:frontend/utils/ConceptoService.dart';
import 'package:frontend/utils/TurnoService.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import '../utils/apiclient.dart';
import '../utils/file_picker.dart';
import '../model.dart' as model;
import '../components/Fila.dart';
import '../components/error_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

class DetalleConcepto extends StatefulWidget {
  final model.Usuario usuario;
  final ApiClient apiClient;
  final int idConcepto;

  DetalleConcepto(this.usuario, this.idConcepto) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  _DetalleConceptoState createState() => _DetalleConceptoState();
}

class _DetalleConceptoState extends State<DetalleConcepto> {

  Future<model.Concepto> futureConcepto;

  Timer _timer;

  void _refreshList(Timer t) {
    setState(() {
      futureConcepto = fetchConcepto();
    });
  }

  @override
  void initState() {
    super.initState();
    futureConcepto = fetchConcepto();
    _timer=Timer.periodic(
      new Duration(seconds: 2), _refreshList);
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  Future<model.Concepto> fetchConcepto() async {
    return ConceptoService(widget.apiClient).get(widget.idConcepto);
  }

  void subirImagen(model.Concepto concepto) async {
    // TODO: error handling
    PickedFile img = await PickedFile.promptUser("image/*");

    try {
      await ConceptoService(widget.apiClient).subirImagen(concepto, img);
      setState(() {
        this.futureConcepto = fetchConcepto();
      });
    } catch (err) {
      print("ERROR subiendo archivo: $err");
    }
  }

  Widget imagenConcepto(model.Concepto concepto) {
    var tieneImagen = concepto.pathImagen != null;
    Widget imagen = tieneImagen
      ? Image.network(
          ApiClient.getUri(concepto.pathImagen).toString(),
          fit: BoxFit.cover,
        )
      : Icon(Icons.add_a_photo, size: 50);

    return RaisedButton(
      padding: EdgeInsets.zero,
      onPressed: () => subirImagen(concepto),
      child: Container(
        width: 200,
        height: 200,
        child: Card(child: imagen),
      ),
    );
  }

  void showQrConceptoDialog(BuildContext context, model.Concepto concepto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
          double totalWidth = MediaQuery.of(context).size.width*0.7;
          return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${concepto.nombre.toUpperCase()}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              Container(
                height: totalWidth,
                width: totalWidth,
                child: QrImage(
                  data: concepto.id.toString(),
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
              SizedBox(
                width: totalWidth/2,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed:() => showErrorDialog(
                    context: context,
                    error: "Funcionalidad no disponible en la versión gratuita."
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: Icon(Icons.print, color: Colors.white),
                      ),
                      Text("IMPRIMIR", style: TextStyle(color: Colors.white)),
                    ],
                  )
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<model.Concepto>(
      future: this.futureConcepto,
      builder: (context, snapshot) {

        if (!snapshot.hasData || snapshot.hasError) {
            // TODO
            return Center(child: CircularProgressIndicator());
        }
        var concepto = snapshot.data;
        var tryAtenderSiguiente = (turno) async {
          try {
            // TODO: usar el turno para algo, habría que incluir verificaicón en el backend
            await ConceptoService(widget.apiClient).atenderSiguiente(concepto);
          } catch (err) {
            showErrorDialog(
              context: context,
              error: err,
            );
          }
          setState(() {
            futureConcepto = fetchConcepto();
          });
        };
        return new Scaffold(
          appBar: AppBar(title: Text("Mis conceptos")),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Text(
                            concepto.nombre,
                            style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.qrcode, color: Colors.black),
                        iconSize: 50,
                        onPressed: () => showQrConceptoDialog(context, concepto),
                      ),
                    ]
                  ),
                ),
                Center(
                  child: imagenConcepto(concepto),
                ),
                Padding( // Línea divisora
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget> [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget> [
                          Text(concepto.maximaEspera != null ? "${concepto.enFila}/${concepto.maximaEspera}" : concepto.enFila.toString()),
                          Icon(Icons.person)
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                Fila(
                  futureTurnos: TurnoService(widget.apiClient).query({"conceptoId": concepto.id.toString()}),
                  onAtenderSiguiente: tryAtenderSiguiente,
                  onScanQrSiguiente: (turno) {
                    js.context.callMethod("scan");
                    var procesar=true;
                    html.window.onMessage.listen((e) {
                      if (procesar) {
                        procesar=false;
                        String codigoQR=e.data;
                        if (codigoQR=='-1'){
                          return;
                        }
                        String dataTurno=turno.uuid;
                        if (codigoQR == dataTurno) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('¡Turno válido! Te atiendo, amigue.')
                              );
                            }
                          );
                          tryAtenderSiguiente(turno);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('¡Turno NO válido! ¡Sos un chante!')
                              );
                            }
                          );
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
