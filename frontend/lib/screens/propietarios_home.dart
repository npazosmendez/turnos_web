import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';
import 'package:frontend/screens/seleccionar_ubicacion.dart';
import 'package:frontend/utils/ConceptoService.dart';
import 'package:flutter/services.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;
import 'detalle_concepto.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PropietariosHome extends StatelessWidget {
  static const String routeName = '/propietarios';
  final model.Usuario usuario;

  PropietariosHome(this.usuario);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Mis Conceptos"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result=await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: FormNuevoConcepto(usuario), // TODO
              );
            }, // TODO
          );
          if (result!=null){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => PropietariosHome(usuario)));
          }
        },
        child: Icon(Icons.add),
        tooltip: "Nuevo concepto",
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Bienvenide, ${usuario.email}!",
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
            ),
            ConceptoList(
              usuario: usuario,
              filtros: {"usuarioId": usuario.id.toString()},
              onTap: (concepto) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetalleConcepto(usuario, concepto.id))
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => PropietariosHome(usuario)));
                }
            )
          ],
        ),
      ),
    );
  }
}

// Define a custom Form widget.
class FormNuevoConcepto extends StatefulWidget {
  final ApiClient apiClient;
  final model.Usuario usuario;

  FormNuevoConcepto(this.usuario) : this.apiClient = ApiClient(usuario.email, usuario.password);

  @override
  _FormNuevoConceptoState createState() => _FormNuevoConceptoState();
}

class _FormNuevoConceptoState extends State<FormNuevoConcepto> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final controllerNombre = TextEditingController();
  final controllerDescripcion = TextEditingController();
  final controllerMaximaEspera = TextEditingController();
  static const String _mapsApiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY", defaultValue: "AIzaSyBU1Lyj4x7qXm6vqcT0aG9OpJ-5zCs_JNM");
  String _searchAddress;
  GeoCoord _addressCoords;
  bool _addressConfirmed;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerNombre.dispose();
    super.dispose();
  }

@override
  void initState(){
    super.initState();
    GoogleMap.init('API_KEY');
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controllerNombre,
          decoration: InputDecoration(
            labelText: 'Nombre'
          ),
        ),
        TextField(
          controller: controllerDescripcion,
          decoration: InputDecoration(
            labelText: 'Descripción'
          ),
        ),
        new TextField(
          controller: controllerMaximaEspera,
          decoration: new InputDecoration(labelText: "Máxima espera (opcional)"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        ),
        RaisedButton(
          child: Text("Seleccionar Ubicación"),
          onPressed: () async {
            _searchAddress = null;
            _addressCoords = null;   
            _addressConfirmed = false; 
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => 
              SeleccionarUbicacion(
                searchCoordinates, 
                onAddressLocationMarkerTap, 
                onChangedAddressValue, 
                onConfirmAddressButtonPressed,
                onMapTap,
                showDefaultDialog)));
          }
        ),
        RaisedButton(
          child: Text("Submit"),
          onPressed: () async {
            if(controllerNombre.text == '') {
              showDefaultDialog('Por favor ingrese un nombre!');
              return;
            }
            if(controllerDescripcion.text == '') {
              showDefaultDialog('Por favor ingrese una descripción!');
              return;
            }

            if (_addressConfirmed == false || _addressCoords == null) {
              showDefaultDialog('Por favor confirme una ubicación!');
              return;
            }

            print("Adding concept:");
            print(controllerNombre.text);
            print(controllerDescripcion.text);
            print(_addressCoords.latitude);
            print(_addressCoords.longitude);
            try {
              ConceptoService(widget.apiClient).create(
                controllerNombre.text,
                controllerDescripcion.text,
                int.tryParse(controllerMaximaEspera.text),
                _addressCoords.latitude,
                _addressCoords.longitude
              );
              Navigator.of(context).pop(true);
            } catch (ex) {
              // TODO: handle
            }


          },
        ),
      ],
    );
  }

  Future<GeoCoord> searchCoordinates() async {
    print("Starting to look up for the address...");
    const _host = 'https://maps.google.com/maps/api/geocode/json';
    print("Looking for address of: " + _searchAddress);
    var encoded = Uri.encodeComponent(_searchAddress);
    final uri = Uri.parse('$_host?key=$_mapsApiKey&address=$encoded');

    http.Response response = await http.get (uri);
    final responseJson = json.decode(response.body);

    if(responseJson.containsKey('results')) {
      if (responseJson['results'].length > 0) {
        print(responseJson['results'].length);
        var lat = responseJson['results'][0]['geometry']['location']['lat'];
        var lng = responseJson['results'][0]['geometry']['location']['lng'];
        setState(() {
          _addressCoords = GeoCoord(lat, lng);
        });
        return GeoCoord(lat, lng);
      }
    }
    return null;
  }

  void onMapTap(GeoCoord coords) {
    setState(() {
      _addressCoords = coords;
    });
  }


  void onAddressLocationMarkerTap(markerId) async {
    await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(
        (_searchAddress != null)? _searchAddress :
        'This dialog was opened by tapping on the marker!\n'
        'Marker ID is $markerId',
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: Navigator.of(context).pop,
          child: Text('Cerrar'),
        ),
      ],
      ),
    );
  }

  void onChangedAddressValue(val) {
    setState(() {
      _searchAddress = val;
    });
  }

  void onConfirmAddressButtonPressed() async {
    if (_searchAddress != null || _addressCoords != null) {
      _addressConfirmed = true;
      Navigator.of(context).pop(); 
      print("Address confirmed correctly");
    } else {
      print("Confirmar dirección null! Error");
      showIngressAddressDialog();
    }
  }

  void showDefaultDialog(String text) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Cerrar'),
          ),
        ],
        ),
      );
  }
  
  void showIngressAddressDialog() async {
    showDefaultDialog('Por favor ingrese una ubicación');
  }
}