import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model.dart' as model;
import '../utils/apiclient.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {

  const LoginPage({this.title, this.onSignedIn});
  final Function(model.Usuario usuario) onSignedIn;
  final String title;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool authFailed = false;
  int authResponseStatus = -1;
  final emailInputController = TextEditingController(text: "elver@gmail.com");
  final passwordInputController = TextEditingController(text: "12345");

  void login() async {
    var email = emailInputController.text;
    var password = passwordInputController.text;
    try {
      var apiClient = ApiClient(email, password);
      final response = await apiClient.get("/usuarios/login");
      if((authResponseStatus = response.statusCode) == 200) {
        var body = await response.stream.bytesToString();
        this.widget.onSignedIn(model.Usuario.fromJson(json.decode(body)));
        return;
      }
    } catch (ex) {
      print(ex);
      // TODO: probablemente un error de conexión o que el backend no responde.
      // No termino de entender las excepciones del paquete http.
    }
    setAuthFailed();
  }

  void setAuthFailed() {
    print(1123);
    setState(() {
      this.authFailed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: 400,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                        "Accedé a tu cuenta",
                        style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: emailInputController,
                      decoration: InputDecoration(
                        hintText: 'email',
                        icon: Icon(Icons.email),
                      ),
                    ),
                    TextField(
                      controller: passwordInputController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'constraseña'
                      ),
                      obscureText: true,
                    ),
                    Text(
                      this.authFailed ? "Falló la autenticación (${this.authResponseStatus})" : "",
                      style: TextStyle( color: Colors.red)),
                    RaisedButton(
                      hoverElevation: 5,
                      onPressed: this.login,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}