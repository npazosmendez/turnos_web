import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {

  const LoginPage({this.title, this.onSignedIn});
  final Function(String email) onSignedIn;
  final String title;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailInputController = TextEditingController();

  Future<bool> login(String username, String password) async {
    final response = await http.get(
      "http://localhost:30000/hola", // TODO: tomar de config
      headers: {"Authorization": "Basic $username:$password"},
    );
    return response.statusCode == 200;
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
                      decoration: InputDecoration(
                        hintText: 'Password'
                      ),
                      obscureText: true,
                    ),
                    RaisedButton(
                        onPressed: (){
                          // TODO: probar user y pass contra el backend.
                          // Si da 200, ejecutar el callback. Si no, mostrar un mensaje de falla.
                          widget.onSignedIn(emailInputController.text);
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