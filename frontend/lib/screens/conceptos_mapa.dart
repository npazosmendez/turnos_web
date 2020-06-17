// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:location/location.dart';
import 'package:frontend/utils/apiclient.dart';

import '../model.dart' as model;
import '../utils/ConceptoService.dart';


class ConceptosMapa extends StatelessWidget {

  final void Function(dynamic, model.Concepto) onConceptoMarkerTapCallback;
  final void Function(dynamic, [String text]) onRawMarkerTapCallback;
  final ApiClient apiClient;
  final _key = GlobalKey<GoogleMapStateBase>();
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _location = new Location();
  final Future<bool> isLocationServiceEnabled;

  ConceptosMapa(this.onConceptoMarkerTapCallback, this.onRawMarkerTapCallback, this.apiClient, this.isLocationServiceEnabled);

  @override
  Widget build(BuildContext context) {
    final widget = Scaffold(
      appBar: AppBar(
          title: Text("Mapa con los conceptos")
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GoogleMap(
              key: _key,
              markers: {},
              initialZoom: 14,
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
          // _buildContainer()
        ]
      )
    );
    addPositionAndConceptosMarkers();
    return widget;
  }

  void addPositionAndConceptosMarkers() async {
    bool _locationServiceEnabled = await this.isLocationServiceEnabled;
    if (_locationServiceEnabled) {
      print("Service location enabled and permission granted");
      LocationData currentPosition = await _location.getLocation();
      GeoCoord currentGeoCoord = GeoCoord(currentPosition.latitude, currentPosition.longitude);
      moveCameraToPosition(currentGeoCoord);
      addRawMarker(currentGeoCoord, 'Tu estás aquí!');
      var queryParameters = {
        "latitud": currentPosition.latitude.toString(),
        "longitud": currentPosition.longitude.toString(),
        "radio": "3500"
      };
      List<model.Concepto> conceptosCercanos = await ConceptoService(this.apiClient).query(queryParameters);
      print("Conceptos encontrados: " + conceptosCercanos.length.toString());
      for(final conceptoCercano in conceptosCercanos){
        addConceptoMarker(conceptoCercano);
      }
    } else {
      print("Service is not enabled or permission has not been granted!");
      List<model.Concepto> todosLosConceptos = await ConceptoService(this.apiClient).query(null);
      for(final concepto in todosLosConceptos){
        addConceptoMarker(concepto);
      }  
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
}









// Widget _buildContainer() {
//     return Align(
//       alignment: Alignment.bottomLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 20.0),
//         height: 150.0,
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: <Widget>[
//             SizedBox(width: 10.0),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _boxes(
//                   "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no",
//                   40.738380, -73.988426,"Gramercy Tavern"),
//             ),
//             SizedBox(width: 10.0),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _boxes(
//                   "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no",
//                   40.761421, -73.981667,"Le Bernardin"),
//             ),
//             SizedBox(width: 10.0),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: _boxes(
//                   "https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
//                   40.732128, -73.999619,"Blue Hill"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _boxes(String _image, double lat,double long,String restaurantName) {
//     return  GestureDetector(
//         onTap: () {
//           // _gotoLocation(lat,long);
//         },
//         child:Container(
//               child: new FittedBox(
//                 child: Material(
//                     color: Colors.white,
//                     elevation: 14.0,
//                     borderRadius: BorderRadius.circular(24.0),
//                     shadowColor: Color(0x802196F3),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Container(
//                           width: 180,
//                           height: 200,
//                           child: ClipRRect(
//                             borderRadius: new BorderRadius.circular(24.0),
//                             child: Image(
//                               fit: BoxFit.fill,
//                               image: NetworkImage(_image),
//                             ),
//                           ),),
//                           Container(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: myDetailsContainer1(restaurantName),
//                           ),
//                         ),

//                       ],)
//                 ),
//               ),
//             ),
//     );
//   }


//   Widget myDetailsContainer1(String restaurantName) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Container(
//               child: Text(restaurantName,
//             style: TextStyle(
//                 color: Color(0xff6200ee),
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold),
//           )),
//         ),
//         SizedBox(height:5.0),
//         Container(
//               child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Container(
//                   child: Text(
//                 "4.1",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 18.0,
//                 ),
//               )),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStarHalf,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//                Container(
//                   child: Text(
//                 "(946)",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 18.0,
//                 ),
//               )),
//             ],
//           )),
//           SizedBox(height:5.0),
//         Container(
//                   child: Text(
//                 "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 18.0,
//                 ),
//               )),
//               SizedBox(height:5.0),
//         Container(
//             child: Text(
//           "Closed \u00B7 Opens 17:00 Thu",
//           style: TextStyle(
//               color: Colors.black54,
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold),
//         )),
//       ],
//     );
//   }
