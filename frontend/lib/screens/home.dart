import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';

import 'propietarios_home.dart';
import 'clientes_home.dart';
import '../model.dart' as model;

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final model.Usuario usuario = ModalRoute.of(context).settings.arguments;
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Navigator.pushNamed(context, PropietariosHome.routeName, arguments: usuario);
              },
              child: Text("Propietarios".toUpperCase(),
                  style: TextStyle(fontSize: 14)),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Navigator.pushNamed(context, ClientesHome.routeName, arguments: usuario);
              },
              child: Text("Clientes".toUpperCase(),
                  style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

