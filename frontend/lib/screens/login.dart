import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model.dart' as model;
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
  final emailInputController = TextEditingController(text: "elver@gmail.com");
  final passwordInputController = TextEditingController(text: "12345");

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        "http://localhost:3000/usuarios/login", // TODO: tomar de config
        headers: {"Authorization": "Basic $username:$password"},
      );
      if(response.statusCode == 200) {
        this.widget.onSignedIn(model.Usuario.fromJson(json.decode(response.body)));
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      // TODO: log and handle
      return false;
    }
  }

  void setAuthFailed() {
    setState(() {
      this.authFailed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                    TextField(
                      controller: emailInputController,
                      decoration: InputDecoration(
                        hintText: 'Username'
                      ),
                    ),
                    TextField(
                      controller: passwordInputController,
                      decoration: InputDecoration(
                        hintText: 'Password'
                      ),
                      obscureText: true,
                    ),
                    Text(
                      this.authFailed ? "Falló la autenticación" : "",
                      style: TextStyle( color: Colors.red)),
                    RaisedButton(
                        onPressed: () async {
                          if (! await this.login(emailInputController.text, passwordInputController.text)) {
                            setAuthFailed();
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        child: Text('Login',style: TextStyle(
                            fontSize: 20.0
                        ),),),
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