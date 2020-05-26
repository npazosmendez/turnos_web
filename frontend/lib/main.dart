import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as Foundation;
import 'screens/propietarios_home.dart';
import 'screens/clientes_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turnos y más turnos',
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'quieromiturno.com'),
        '/propietarios': (context) => PropietariosHome(),
        '/clientes': (context) => ClientesHome(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<String> rest(String url) async {
  final response=await http.get(url);
  if (response.statusCode==200){
    return response.body.toString(); 
  } else {
    throw Exception('Failed to load');
  }
}

class _MyHomePageState extends State<MyHomePage> {
    
  String _respuesta;

  void initState() {
    super.initState();
    _respuesta = 'nada';
  }

  void _llamaRest() {
       String url='/hola';
       if(Foundation.kDebugMode) {
         url='http://localhost'+url;
        }
       rest(url).then( 
        (value) { 
          setState(() {
            _respuesta=value;
          });
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Navigator.pushNamed(context, '/propietarios');
              },
              child: Text("Propietarios".toUpperCase(),
                style: TextStyle(fontSize: 14)),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Navigator.pushNamed(context, '/clientes');
              },
              child: Text("Clientes".toUpperCase(),
                style: TextStyle(fontSize: 14)),
            ),
            Text(
              'Resultado de la llamada REST:',
            ),
            Text(
              '$_respuesta',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>_llamaRest(),
        tooltip: 'Ejecutar call REST',
        child: Icon(Icons.cloud),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
