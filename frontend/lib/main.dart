import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(TurnosApp());
}

class TurnosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turnos y más turnos',
      initialRoute: '/',
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
