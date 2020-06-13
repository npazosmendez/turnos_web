import 'package:flutter/material.dart';
import 'package:frontend/screens/clientes_home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/propietarios_home.dart';
import 'package:frontend/screens/register.dart';
import 'screens/home.dart';
import './model.dart';
import 'dart:html';

void main() {
  initDom();
  print(const String.fromEnvironment("ASD"));
  runApp(TurnosApp());
}

void initDom() {
  // Workaround cochino para templatear el index.html
  if(querySelector("#google_maps_api") == null) {
    // Evita agregarlo más de una vez
    var script = new ScriptElement();
    script.id = "google_maps_api";
    // flutter run -d chrome --dart-define=GOOGLE_MAPS_API_KEY=mi_api_key
    const String apiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY", defaultValue: "AIzaSyBU1Lyj4x7qXm6vqcT0aG9OpJ-5zCs_JNM");
    script.src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey&callback=initMap';
    document.body.append(script);
  }
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
      ClientesHome.routeName: (context) => ClientesHome(usuario)
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
