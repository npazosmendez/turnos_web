import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/utils/UsuarioService.dart';
import '../model.dart' as model;
import 'dart:math';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String authError;
  final emailInputController = TextEditingController(text: "");
  final passwordInputController = TextEditingController(text: "");

  void login() async {
    var email = emailInputController.text;
    var password = passwordInputController.text;
    try {
      model.Usuario usuario = await UsuarioService.login(email, password);
      model.Usuario.setLocalCredentials(usuario);
      Navigator.pushNamed(context, HomePage.routeName);
      return;
    } catch (err) {
      setAuthError(err.toString());
    }
  }

  void setAuthError(String err) {
    setState(() {
      this.authError = err;
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
                width: min(400, MediaQuery.of(context).size.width*0.8),
                height: min(400, MediaQuery.of(context).size.height*0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                        "Accedé a tu cuenta".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
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
                      this.authError == null ? "" : "Falló la autenticación ($authError)",
                      style: TextStyle( color: Colors.red)),
                    RaisedButton(
                      color: Colors.blue,
                      onPressed: this.login,
                      child: Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.pushNamed(context, RegisterPage.routeName),
                      textColor: Colors.blue,
                      child: Text('CREAR CUENTA')
                    )
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