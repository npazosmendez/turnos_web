import 'package:flutter/material.dart';
import 'package:frontend/utils/ConceptoService.dart';

import '../utils/apiclient.dart';
import '../utils/file_picker.dart';
import '../model.dart' as model;
import 'package:qr_flutter/qr_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    futureConcepto = fetchConcepto();
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

                Text( // Lista de clientes
                  "<Listado de clientes en fila>",
                  style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),
                ),
                Text(
                  "<Listado de clientes en fila>",
                  style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),
                ),

              ],
            ),
          ),
        );
      }
    );
  }
}
