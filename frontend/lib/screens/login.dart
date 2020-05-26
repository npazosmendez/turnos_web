import 'package:flutter/material.dart';

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