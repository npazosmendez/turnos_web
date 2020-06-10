import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/utils/UsuarioService.dart';
import '../model.dart' as model;

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool authFailed = false;
  int authResponseStatus = -1;
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
    } catch (ex) {
      print(ex);
      // TODO: probablemente un error de conexión o que el backend no responde.
      // No termino de entender las excepciones del paquete http.
    }
    setAuthFailed();
  }

  void setAuthFailed() {
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
                        "Accedé a tu cuenta".toUpperCase(),
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