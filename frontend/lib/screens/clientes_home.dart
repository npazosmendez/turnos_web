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

  @override
  _ClientesHomeState createState() => _ClientesHomeState();

}

class _ClientesHomeState extends State<ClientesHome> {
  String _codigoQR;
  ApiClient api;
  
  model.Concepto concepto;
  model.Usuario usuario;

  @override
  void initState(){
    _codigoQR='';

    html.window.onMessage.listen((e) {
      _codigoQR=e.data;
      api=ApiClient(usuario.email,usuario.password);
      ConceptoService(api).get(int.parse(e.data)).then((value) {
        concepto=value;
        Navigator.push(context, 
        MaterialPageRoute(builder: (BuildContext context) => ConfirmarNuevoTurno(usuario, concepto)));
      });
      //html.window.console.log(_codigoQR);
      //html.window.console.log(usuario.id);
      //js.context.callMethod("alert", [ _codigoQR ]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usuario=ModalRoute.of(context).settings.arguments;
    //final model.Usuario usuario = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenide, ${usuario.email}!")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NuevoTurno(usuario)));
                          }
                        ),
                      ),
                      Center(child: Text("Listado de\nConceptos"))
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
                usuario: usuario,
                filtros: {"usuarioId": usuario.id.toString()},
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