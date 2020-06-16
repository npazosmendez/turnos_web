// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

class SeleccionarUbicacion extends StatelessWidget {
  final Future<GeoCoord> Function() onSearchTapCallback;
  final void Function(dynamic) onAddressLocationMarkerTapCallback;
  final void Function(dynamic) onChangedAddressValueCallback;
  final void Function() onConfirmAddressButtonCallback;
  final void Function(GeoCoord) onMapTapCallback;
  final void Function(String) showDefaultDialogCallback;
  final _key = GlobalKey<GoogleMapStateBase>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));

  SeleccionarUbicacion(
      this.onSearchTapCallback,
      this.onAddressLocationMarkerTapCallback,
      this.onChangedAddressValueCallback,
      this.onConfirmAddressButtonCallback,
      this.onMapTapCallback,
      this.showDefaultDialogCallback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: addressInputWidget(),
        ),
        body: Stack(children: <Widget>[
          Positioned.fill(
            child: GoogleMap(
              key: _key,
              markers: {},
              initialZoom: 16,
              initialPosition:
                  GeoCoord(-34.603722, -58.381592), // Buenos Aires, AR
              mapType: MapType.roadmap,
              interactive: true,
              onTap: (coord) => {onMapTap(coord)},
              webPreferences: WebMapPreferences(
                zoomControl: true,
              ),
            ),
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
        ]));
  }

  Widget addressInputWidget() {
    return Container(
        height: 36.0,
        width: 800.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.white),
        child: TextField(
            decoration: InputDecoration(
                hintText: 'Por favor, ingrese su dirección',
                border: InputBorder.none,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 15.0, top: 18.0),
                suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      GoogleMap.of(_key).clearMarkers();
                      GeoCoord addressCoordinates =
                          await this.onSearchTapCallback();
                      if (addressCoordinates != null) {
                        // Location found
                        addAddressLocationMarker(addressCoordinates);
                        moveCameraToPosition(addressCoordinates);
                      } else {
                        this.showDefaultDialogCallback(
                            "No se ha encontrado la dirección. Por favor, intente nuevamente");
                        print(
                            "Coordinates of address are null! Location wasn't found");
                      }
                    },
                    iconSize: 30.0)),
            onChanged: (val) {
              this.onChangedAddressValueCallback(val);
            }));
  }

  void onSearchIconPressed() async {
    GoogleMap.of(_key).clearMarkers();
    GeoCoord addressCoordinates = await this.onSearchTapCallback();
    if (addressCoordinates != null) {
      // Location found
      addAddressLocationMarker(addressCoordinates);
      moveCameraToPosition(addressCoordinates);
    } else {
      this.showDefaultDialogCallback(
          "No se ha encontrado la dirección. Por favor, intente nuevamente");
      print("Coordinates of address are null! Location wasn't found");
    }
  }

  void onMapTap(GeoCoord coord) {
    GoogleMap.of(_key).clearMarkers();
    addAddressLocationMarker(coord);
    this.onMapTapCallback(coord);
  }

  void addAddressLocationMarker(GeoCoord addressLocation) {
    GoogleMap.of(_key).addMarkerRaw(addressLocation, onTap: (markerId) async {
      this.onAddressLocationMarkerTapCallback(markerId);
    });
  }

  void moveCameraToPosition(GeoCoord position) {
    final newBounds = GeoCoordBounds(northeast: position, southwest: position);
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

  void onBuildingSearchResults(String selectedSearch) {
    this.onChangedAddressValueCallback(selectedSearch);
  }
}
