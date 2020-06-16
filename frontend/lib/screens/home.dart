import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';

import 'propietarios_home.dart';
import 'clientes_home.dart';
import '../model.dart' as model;

class HomePage extends StatelessWidget {
  static const String routeName = '/home';
  final model.Usuario usuario;
  HomePage(this.usuario);


  @override
  Widget build(BuildContext context) {
    if (usuario == null) {
      return LoginPage();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Text(
                      "TuTurno",
                      style: TextStyle(color: Colors.blue, fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Para nosotros, siempre estás primero".toUpperCase(),
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              )
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width*0.3,
              child: Column(
                children: [
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () => Navigator.pushNamed(context, PropietariosHome.routeName),
                    child: Text("PROPIETARIOS".toUpperCase(),
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () => Navigator.pushNamed(context, ClientesHome.routeName),
                    child: Text("CLIENTES".toUpperCase(),
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

