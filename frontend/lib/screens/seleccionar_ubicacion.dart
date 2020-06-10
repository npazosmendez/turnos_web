// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:location/location.dart';

import '../model.dart' as model;


class SeleccionarUbicacion extends StatelessWidget {

  // final void Function(dynamic, model.Concepto) onConceptoMarkerTapCallback;
  // final void Function(dynamic, [String text]) onRawMarkerTapCallback;
  final Future<GeoCoord> Function() onSearchTapCallback;
  final void Function(dynamic) onAddressLocationMarkerTapCallback;
  final void Function(dynamic) onChangedAddressValueCallback;
  final void Function() onConfirmAddressButtonCallback;
  final _key = GlobalKey<GoogleMapStateBase>();
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _location = new Location();

  SeleccionarUbicacion(this.onSearchTapCallback, this.onAddressLocationMarkerTapCallback, this.onChangedAddressValueCallback, this.onConfirmAddressButtonCallback);

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
                    onPressed: () async {
                      GoogleMap.of(_key).clearMarkers();
                      GeoCoord addressCoordinates = await this.onSearchTapCallback();
                      if (addressCoordinates != null) {
                        // Location found
                        addAddressLocationMarker(addressCoordinates);
                        moveCameraToPosition(addressCoordinates);
                      } else {
                        print("Coordinates of address are null! Location wasn't found");
                      }
                    },
                    iconSize: 30.0
                  )
                ),
                onChanged: (val) {
                  this.onChangedAddressValueCallback(val);
                }
              )
            ),
            )
          ),
          Positioned(
            left: 16,
            right: kIsWeb ? 60 : 16,
            bottom: 16,
            child: Row(
              children: <Widget>[
                Spacer(),
                ...buildConfirmAddressButton(),
              ],
            ),
          ),
        ]
      )
    );
  }

  void addAddressLocationMarker(GeoCoord addressLocation) {
    GoogleMap.of(_key).addMarkerRaw(
      addressLocation,
      onTap: (markerId) async {
        this.onAddressLocationMarkerTapCallback(markerId);
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

  List<Widget> buildConfirmAddressButton() => [
    const SizedBox(width: 16),
    RaisedButton.icon(
      color: Colors.red,
      textColor: Colors.white,
      icon: Icon(Icons.pin_drop),
      label: Text('Confirmar Ubicación'),
      onPressed: () {
        GoogleMap.of(_key).clearMarkers();
        this.onConfirmAddressButtonCallback();
      },
    ),
  ];  

}






