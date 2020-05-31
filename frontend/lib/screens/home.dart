import 'package:flutter/material.dart';
import 'propietarios_home.dart';
import 'clientes_home.dart';
import 'login.dart';
import '../model.dart' as model;

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
          ],
        ),
      ),
    );
  }
}
