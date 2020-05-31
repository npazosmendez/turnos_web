import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'propietarios_home.dart';
import 'clientes_home.dart';
import 'login.dart';
import '../utils/apiclient.dart';
import '../model.dart' as model;

class Image {
  final String name;
  final Uint8List data;
  const Image(this.name, this.data);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  model.Usuario usuario;

  void onSignedIn(model.Usuario usuario) {
    setState( () {
      this.usuario = usuario;
    });
  }

  void getImage(Function(Image img) callback) async {
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
        var img = Image(file.name, reader.result);
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
    getImage((Image img) async {
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

  @override
  Widget build(BuildContext context) {

    if (this.usuario == null) {
      // Requerir autenticación
      return LoginPage(title: "Login", onSignedIn: onSignedIn);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Turnos"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PropietariosHome(this.usuario)));
              },
              child: Text("Propietarios".toUpperCase(),
                style: TextStyle(fontSize: 14)),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ClientesHome(this.usuario)));
              },
              child: Text("Clientes".toUpperCase(),
                style: TextStyle(fontSize: 14)),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
              onPressed: _subirImagen,
              child: Text("Subir imagen".toUpperCase(),
                style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
