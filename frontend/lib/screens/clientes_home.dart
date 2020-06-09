import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/components/TurnoList.dart';
import 'package:frontend/utils/apiclient.dart';
import '../model.dart' as model;
import 'nuevo_turno.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'confirmar_nuevo_turno.dart';
import '../utils/ConceptoService.dart';
import '../utils/apiclient.dart';

class ClientesHome extends StatefulWidget {
  static const String routeName = '/clientes';
  final model.Usuario usuario;
  ClientesHome(this.usuario);

  @override
  _ClientesHomeState createState() => _ClientesHomeState();

}

class _ClientesHomeState extends State<ClientesHome> {
  ApiClient api;  
  model.Concepto concepto;
  String _codigoQR;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenide, ${widget.usuario.email}!")),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Pedir nuevo turno",
                style: TextStyle( color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.blueGrey,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.list),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NuevoTurno(widget.usuario)));
                          }
                        ),
                      ),
                      Center(child: Text("Conceptos"))
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.blueGrey,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                            icon: Icon(Icons.map),
                            color: Colors.white,
                          onPressed: () {}
                        ),
                      ),
                      Center(child: Text("Mapa"))
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.blueGrey,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            color: Colors.white,
                          onPressed: () {
                            js.context.callMethod("scan");
                            var procesar=true;
                            html.window.onMessage.listen((e) {
                              if (procesar) {
                                procesar=false;
                                _codigoQR=e.data;
                                api=ApiClient(widget.usuario.email,widget.usuario.password);
                                ConceptoService(api).get(int.parse(_codigoQR)).then((value) {
                                  concepto=value;
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => ConfirmarNuevoTurno(widget.usuario, concepto)
                                    )
                                  );
                                });
                              }
                          });
                          }
                        ),
                      ),
                      Center(child: Text("Usar QR"))
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Mis turnos",
                style: TextStyle( color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            TurnoList(
                usuario: widget.usuario,
                filtros: {"usuarioId": widget.usuario.id.toString()},
                mjeSinResultado: "No tenés turnos pendientes",
                onTap: (concepto) {
                }
            )
          ],
        ),
      ),
    );
  }
}