import 'package:flutter/material.dart';
import 'package:frontend/screens/clientes_home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/propietarios_home.dart';
import 'package:frontend/screens/mapas.dart';
import 'package:frontend/screens/register.dart';
import 'screens/home.dart';
import './model.dart';

void main() {
  runApp(TurnosApp());
}

class TurnosApp extends StatelessWidget {

  WidgetBuilder routeFor(routeName) {
    var loggedOutRoutes = <String, WidgetBuilder> {
      LoginPage.routeName: (context) => LoginPage(),
      RegisterPage.routeName: (context) => RegisterPage(),
    };
    var loginRoute = loggedOutRoutes[LoginPage.routeName];

    if(!Usuario.localCredentialsExist()) {
      // When user is not logged in
      if (loggedOutRoutes.containsKey(routeName)) {
        return loggedOutRoutes[routeName];
      }
      return loginRoute;
    }

    var usuario = Usuario.fromLocalCredentials();
    var loggedInRoutes = <String, WidgetBuilder> {
      HomePage.routeName: (context) => HomePage(usuario),
      PropietariosHome.routeName: (context) => PropietariosHome(usuario),
      ClientesHome.routeName: (context) => ClientesHome(usuario),
      MapasPage.routeName: (context) => MapasPage()
    };

    // User is logged in
    // can access both routes
    if (loggedInRoutes.containsKey(routeName)) {
      return loggedInRoutes[routeName];
    } else if (loggedOutRoutes.containsKey(routeName)) {
      return loggedOutRoutes[routeName];
    }
    return loginRoute;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turnos y más turnos',
      initialRoute: '/login',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder = routeFor(settings.name);
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
