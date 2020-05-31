import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../utils/apiclient.dart';
import 'dart:typed_data';

class SelectedImage {
  final String name;
  final Uint8List data;
  const SelectedImage(this.name, this.data);
}

class DetalleConcepto extends StatelessWidget {
  final model.Usuario usuario;
  final model.Concepto concepto;

  const DetalleConcepto(this.usuario, this.concepto);

  void getImage(Function(SelectedImage img) callback) async {
    var uploadInput = html.FileUploadInputElement();
    uploadInput.accept = "image/*";

    uploadInput.onChange.listen((e) {
      // TODO: error handling
      if (uploadInput.files.length == 0){
        print("No se encontraron archivos.");
        return;
      }

      final file = uploadInput.files[0];

      var reader =  html.FileReader();
      reader.onLoadEnd.listen((e) async {
        var img = SelectedImage(file.name, reader.result);
        callback(img);
      });
      reader.onError.listen((e) {
        print("Error leyendo el archivo.");
      });

      reader.readAsArrayBuffer(file);
    });

    uploadInput.click();
  }

  void _subirImagen() async {
    // TODO: error handling
    getImage((SelectedImage img) async {
      var multipartFile = http.MultipartFile.fromBytes(
        "imagen_concepto",
        img.data,
        filename: img.name);

      var apiClient = ApiClient(this.usuario.email, this.usuario.password);
      try {
        var response = await apiClient.postMultipartFile("/conceptos/1/asociar_imagen", multipartFile);
        if (response.statusCode != 200) {
          print("Falló la subida del archivo (${response.statusCode}).");
        }
      } catch (err) {
        print("ERROR subiendo archivo: $err");
      }
    });
  }

  Widget configuracionConcepto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            this.concepto.nombre,
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
                "Espea máxima: 20",
                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.normal),
              ),
              Text(
                "Límite diario: 100",
                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ]
          ),
        ),
      ],
    );
  }

  Widget imagenConcepto() {
    var foto = true;
    return Card(
      child: foto
        ? Image.network(
          'https://dummyimage.com/400x600/000/fff',
          fit: BoxFit.cover,
        )
        : RaisedButton(
          onPressed: _subirImagen,
          child: Icon(Icons.add_a_photo, size: 50),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Mis conceptos")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Flexible(child: configuracionConcepto()),
                  Container(
                    width: 200,
                    height: 200,
                    child: imagenConcepto(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Divider(
                thickness: 1,
                color: Colors.black54,
              ),
            ),
            Text(
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
}
