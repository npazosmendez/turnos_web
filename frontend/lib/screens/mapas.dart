// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:frontend/screens/home.dart';

class MapasPage extends StatefulWidget {
  static const String routeName = '/mapas';
  @override
  _MapasPageState createState() => _MapasPageState();
  
}

class _MapasPageState extends State<MapasPage> {

  @override
  void initState(){
    super.initState();
    GoogleMap.init('API_KEY');
    WidgetsFlutterBinding.ensureInitialized();
    // Navigator.pushNamed(context, HomePage.routeName);
  }
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  Location _location = new Location();
  LocationData _currentPosition;
  String _searchAddress;
  String _mapStyle;

  Future<bool> isServiceEnabledAndPermissionGranted() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        print("Location service isn't enabled");
        return false;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Location permission denied");
        return false;
      }
    }
    return true;
  }

  void addCurrentPositionMarker() async {
    bool isServiceEnabledAndPermissionGranted = await this.isServiceEnabledAndPermissionGranted();

    if (isServiceEnabledAndPermissionGranted) {
      LocationData currentPosition = await _location.getLocation();
      _currentPosition = currentPosition;
      GeoCoord currentGeoCoord = GeoCoord(_currentPosition.latitude, _currentPosition.longitude);
      moveCameraToPosition(currentGeoCoord);
      addRawMarket(currentGeoCoord, 'Your position!');
    } else {
      print("Service not enabled or permission not granted!");
    }

  }

  void addRawMarket(GeoCoord position, [String text]) {
      GoogleMap.of(_key).addMarkerRaw(
        position,
        onTap: (markerId) async {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                (text != null)? text :
                'This dialog was opened by tapping on the marker!\n'
                'Marker ID is $markerId',
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text('CLOSE'),
                ),
              ],
            ),
          );
        }
      );
  }

  void moveCameraToPosition(GeoCoord position) {
    final newBounds = GeoCoordBounds(
    northeast: position, 
    southwest: position
    );
    GoogleMap.of(_key).moveCamera(newBounds);
  }

  void searchAndNavigate() async {
    print("Starting to look up for the address...");
    GoogleMap.of(_key).clearMarkers();
    const _host = 'https://maps.google.com/maps/api/geocode/json';
    const apiKey = "<apiJuan>";
    print("Looking for address of: " + _searchAddress);
    var encoded = Uri.encodeComponent(_searchAddress);
    final uri = Uri.parse('$_host?key=$apiKey&address=$encoded');

    http.Response response = await http.get (uri);
    final responseJson = json.decode(response.body);
    // final responseJson = json.decode(response.body) as Map;

    if(responseJson.containsKey('results')) {
      if (responseJson['results'].length > 0) {
        print(responseJson['results'].length);
        var lat = responseJson['results'][0]['geometry']['location']['lat'];
        var lng = responseJson['results'][0]['geometry']['location']['lng'];
        print(lat);
        print(lng);
        GeoCoord positionFound = GeoCoord(lat, lng);
        addRawMarket(positionFound, 'Address found for: ' + _searchAddress);
        moveCameraToPosition(positionFound);
      }
    } else {
      print("No results found!");
    }  
  }

  List<Widget> _buildAddButtons() => [
    const SizedBox(width: 16),
    FloatingActionButton(
      child: Icon(Icons.pin_drop),
      onPressed: () async {
        if (_currentPosition != null) {
          GeoCoord position = GeoCoord(_currentPosition.latitude, _currentPosition.longitude);
          addRawMarket(position, "Your position!");
        }
      },
    ),
    const SizedBox(width: 16),
    FloatingActionButton(
      child: Icon(Icons.directions),
      onPressed: () {
        GeoCoord currentGeoCoord = GeoCoord(_currentPosition.latitude, _currentPosition.longitude);
        moveCameraToPosition(currentGeoCoord);
      },
    ),
  ];  

  List<Widget> _buildClearButtons() => [
    const SizedBox(width: 16),
    RaisedButton.icon(
      color: Colors.red,
      textColor: Colors.white,
      icon: Icon(Icons.pin_drop),
      label: Text('CLEAR MARKERS'),
      onPressed: () {
        GoogleMap.of(_key).clearMarkers();
      },
    ),
  ];


  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Google Map'),
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {

            }
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                
              }
            )
          ]
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: GoogleMap(
                key: _key,
                markers: {
                  // if (_currentPosition != null)
                  //   Marker(GeoCoord(_currentPosition.latitude, _currentPosition.longitude))
                },
                initialZoom: 12,
                initialPosition:
                      GeoCoord(-34.603722, -58.381592), // Buenos Aires, AR
                mapType: MapType.roadmap,
                mapStyle: _mapStyle,
                interactive: true,
                onTap: (coord) =>
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(coord?.toString()),
                  duration: const Duration(seconds: 2),
                )),
                mobilePreferences: const MobileMapPreferences(
                  trafficEnabled: true,
                ),
                webPreferences: WebMapPreferences(
                  fullscreenControl: true,
                  zoomControl: true,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: kIsWeb ? 60 : 16,
              child: FloatingActionButton(
                child: Icon(Icons.my_location),
                onPressed: () async {
                  addCurrentPositionMarker();
                }
              )
            ),
            Positioned(
              left: 16,
              right: kIsWeb ? 60 : 16,
              bottom: 16,
              child: Row(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (context, constraints) =>
                        constraints.maxWidth < 1000
                            ? Row(children: _buildClearButtons())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildClearButtons(),
                              ),
                  ),
                  Spacer(),
                  ..._buildAddButtons(),
                ],
              ),
            ),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 50.0,
                  width: 800.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Por favor, ingrese su dirección',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchAndNavigate,
                      iconSize: 30.0
                      // onPressed: searcAndNavigate
                    )
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchAddress = val;
                    });
                  }
                )
              ),
              )
            ),
          ],
        ),
      );
}
