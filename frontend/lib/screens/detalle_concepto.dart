import 'package:flutter/material.dart';
import 'package:frontend/utils/ConceptoService.dart';
import 'package:frontend/utils/TurnoService.dart';
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

  Widget configuracionConcepto(model.Concepto concepto) {
    // TODO: llenar con info real y rediseñar
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            concepto.nombre,
            style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Dirección: Pueyrredón 1204 - C.A.B.A",
                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.normal),
              ),
              Text(
                "Espera máxima: ${concepto.maximaEspera != null ? concepto.maximaEspera : "-"}",
                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ]
          ),
        ),
      ],
    );
  }

  Widget imagenConcepto(model.Concepto concepto) {
    var tieneImagen = concepto.pathImagen != null;
    Widget imagen = tieneImagen
      ? Image.network(
          ApiClient.getUri(concepto.pathImagen).toString(),
          fit: BoxFit.contain,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<model.Concepto>(
      future: this.futureConcepto,
      builder: (context, snapshot) {

        if (!snapshot.hasData || snapshot.hasError) {
            // TODO
            return Center(child: CircularProgressIndicator());
        }

        return new Scaffold(
          appBar: AppBar(title: Text("Mis conceptos")),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Padding( // La configuración y la imagen
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Flexible(child: configuracionConcepto(snapshot.data)),
                      imagenConcepto(snapshot.data),
                      QrImage(
                        data: snapshot.data.id.toString(),
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                    ],
                  ),
                ),

                Padding( // Línea divisora
                  padding: EdgeInsets.all(16.0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.black54,
                  ),
                ),

                Fila(
                  futureTurnos: TurnoService(widget.apiClient).query({"conceptoId": snapshot.data.id.toString()}),
                  onCancelSiguiente: (turno) async {
                    try {
                      // TODO: usar el turno para algo, habría que incluir verificaicón en el backend
                      await ConceptoService(widget.apiClient).atenderSiguiente(snapshot.data);
                    } catch (err) {
                      showErrorDialog(
                        context: context,
                        error: err,
                      );
                    }
                    setState(() {
                      futureConcepto = fetchConcepto();
                    });
                  },
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
                        //String dataTurno=turno.numero.toString()+'+'+turno.uuid;
                        String dataTurno=turno.uuid;
                        if (codigoQR == dataTurno) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('Turno válido ! Te atiendo amigue')
                              );
                            }
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('Turno NO válido ! Sos un chante !')
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
