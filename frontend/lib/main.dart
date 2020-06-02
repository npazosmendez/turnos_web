import 'package:flutter/material.dart';
import 'package:frontend/screens/clientes_home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/propietarios_home.dart';
import 'screens/home.dart';

void main() {
  runApp(TurnosApp());
}

class TurnosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turnos y más turnos',
      initialRoute: '/login',
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        PropietariosHome.routeName: (context) => PropietariosHome(),
        ClientesHome.routeName:  (context) => ClientesHome()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
