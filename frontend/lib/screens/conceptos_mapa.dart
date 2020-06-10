// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:location/location.dart';

import '../model.dart' as model;


class ConceptosMapa extends StatelessWidget {

  final void Function(dynamic, model.Concepto) onConceptoMarkerTapCallback;
  final void Function(dynamic, [String text]) onRawMarkerTapCallback;
  final _key = GlobalKey<GoogleMapStateBase>();
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _location = new Location();
  final List<model.Concepto> conceptos;

  ConceptosMapa(this.conceptos, this.onConceptoMarkerTapCallback, this.onRawMarkerTapCallback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Mapa con los conceptos")
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GoogleMap(
              key: _key,
              markers: {},
              initialZoom: 12,
              initialPosition:
                    GeoCoord(-34.603722, -58.381592), // Buenos Aires, AR
              mapType: MapType.roadmap,
              interactive: true,
              onTap: (coord) => {},
              webPreferences: WebMapPreferences(
                zoomControl: true,
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: kIsWeb ? 60 : 16,
            child: FloatingActionButton(
              heroTag: "currentPositionMarkerButton",
              child: Icon(Icons.my_location),
              onPressed: () async {
                addPositionAndConceptosMarkers();
              },
            )
          ),
        ]
      )
    );
  }

  void addPositionAndConceptosMarkers() async {
    bool isServiceEnabledAndPermissionGranted = await this.isServiceEnabledAndPermissionGranted();

    if (isServiceEnabledAndPermissionGranted) {
      LocationData currentPosition = await _location.getLocation();
      GeoCoord currentGeoCoord = GeoCoord(currentPosition.latitude, currentPosition.longitude);
      moveCameraToPosition(currentGeoCoord);
      addRawMarker(currentGeoCoord, 'Tu estás aquí!');
      for(final concepto in conceptos){
        addConceptoMarker(concepto);
      }
    } else {
      print("Service is not enabled or permission has not been granted!");
    }
  }

  void addRawMarker(GeoCoord position, [String text, String customIcon]) {
      if (customIcon != null){
        GoogleMap.of(_key).addMarkerRaw(
          position,
          onTap: (markerId) async {
            this.onRawMarkerTapCallback(markerId, text);
          },
          icon: customIcon,
        );
      } else {
        GoogleMap.of(_key).addMarkerRaw(
          position,
          onTap: (markerId) async {
            this.onRawMarkerTapCallback(markerId, text);
          },
        );
      }
      
  }

  void addConceptoMarker(model.Concepto concepto) {
    GeoCoord position = GeoCoord(concepto.latitud, concepto.longitud);
    GoogleMap.of(_key).addMarkerRaw(
      position,
      onTap: (markerId) async {
        this.onConceptoMarkerTapCallback(markerId, concepto);
        for (final concepto in conceptos) {
          print(concepto.descripcion);
        }
      }
    );
  }

  Future<bool> isServiceEnabledAndPermissionGranted() async {
  bool _serviceEnabled;

  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
    if (!_serviceEnabled) {
      print("Location service isn't enabled");
      return false;
    }
  }
  return true;
}

  void moveCameraToPosition(GeoCoord position) {
    final newBounds = GeoCoordBounds(
    northeast: position, 
    southwest: position
    );
    GoogleMap.of(_key).moveCamera(newBounds);
  }
}






