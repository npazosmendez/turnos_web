import 'package:flutter/material.dart';
import 'package:frontend/components/TurnoList.dart';
import '../model.dart' as model;
import 'nuevo_turno.dart';

class ClientesHome extends StatelessWidget {
  static const String routeName = '/clientes';

  @override
  Widget build(BuildContext context) {
    final model.Usuario usuario = ModalRoute.of(context).settings.arguments;

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
                      Center(child: Text("Listado de Conceptos"))
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
                          onPressed: () {}
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