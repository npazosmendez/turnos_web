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
      appBar: AppBar(
        title: Text("Turnos"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.blue,
              onPressed: () => Navigator.pushNamed(context, PropietariosHome.routeName),
              child: Text("Propietarios".toUpperCase(),
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () => Navigator.pushNamed(context, ClientesHome.routeName),
              child: Text("Clientes".toUpperCase(),
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

