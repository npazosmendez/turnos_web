import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/utils/UsuarioService.dart';

import '../model.dart';
import 'propietarios_home.dart';
import 'clientes_home.dart';
import '../model.dart' as model;

class RegisterPage extends StatelessWidget {
  static const String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: RegisterForm()
            ),
          )
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {

  @override
  _RegisterFormState createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {

  final _formKey = GlobalKey<FormState>();
  var nombre = "";
  var apellido = "";
  var email = "";
  var password = "";

  registerExitoso(context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Usuario creado!")));
    Future.delayed(Duration(seconds: 3), () => Navigator.pushNamed(context, LoginPage.routeName));
  }

  Future<Usuario> register(context) async{
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      UsuarioService.register(nombre, apellido, email, password).then((value) => {
        registerExitoso(context)
      }).catchError((error) => {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.toString())))
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          children: <Widget>[
            TextFormField(
              onSaved: (val) => { nombre = val },
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
              validator: (value) {
                if (value.length < 3) {
                  return 'Minimo 3 caracteres';
                }
                return null;
              },
            ),
            TextFormField(
              onSaved: (val) => { apellido = val },
              decoration: const InputDecoration(
                labelText: 'Apellido',
              ),
              validator: (value) {
                if (value.length < 3) {
                  return 'Minimo 3 caracteres';
                }
                return null;
              },
            ),
            TextFormField(
              onSaved: (val) => { email = val },
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value.length < 3) {
                  return 'Minimo 3 caracteres';
                }
                return null;
              },
            ),
            TextFormField(
              onSaved: (val) => { password = val },
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
              validator: (value) {
                if (value.length < 6) {
                  return 'Minimo 6 caracteres';
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () => register(context),
                child: Text(
                  'CREAR',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
              )
            )
          ]
      )
    );
  }
}
