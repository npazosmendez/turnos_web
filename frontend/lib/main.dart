import 'package:flutter/material.dart';
import 'package:frontend/screens/clientes_home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/propietarios_home.dart';
import 'screens/home.dart';
import './model.dart';

void main() {
  runApp(TurnosApp());
}

class TurnosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turnos y más turnos',
      initialRoute: '/login',
      onGenerateRoute: (RouteSettings settings) {
        if(!Usuario.localCredentialsExist()) {
          return MaterialPageRoute(
            builder: (ctx) => LoginPage(),
          );
        }
        var usuario = Usuario.fromLocalCredentials();
        var routes = <String, WidgetBuilder> {
          LoginPage.routeName: (context) => LoginPage(),
          HomePage.routeName: (context) => HomePage(usuario),
          PropietariosHome.routeName: (context) => PropietariosHome(usuario),
          ClientesHome.routeName: (context) => ClientesHome(usuario)
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(
          // NOTE: si usamos rutas generadas en vez de named routes,
          // no tienen un nombre para usar el .withName. Con esto de abajo
          // se lo agregamos.
          settings: RouteSettings(name: settings.name),
          builder: (ctx) => builder(ctx),
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
