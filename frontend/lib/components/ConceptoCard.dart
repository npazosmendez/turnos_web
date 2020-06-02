import 'package:flutter/material.dart';
import 'package:frontend/components/ConceptoList.dart';

import '../utils/apiclient.dart';
import '../model.dart' as model;

class ConceptoCard extends StatelessWidget {
  final model.Concepto concepto;
  final Function(model.Concepto) onTap;

  const ConceptoCard(this.concepto, {this.onTap});

  String getImageUrl() {
    String path = concepto.pathImagen != null ? concepto.pathImagen : '/imagenes_conceptos/fallback.svg';
    return ApiClient.getUri(path).toString();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      constraints: BoxConstraints(
          maxWidth: 400
      ),
      child:Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(
              getImageUrl(),
              fit: BoxFit.cover
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                child: Text(
                  concepto.nombre,
                  style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                )
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Text(
                  concepto.descripcion,
                  style: TextStyle(fontSize: 15),
                )
            ),
          ],
        ),
      )
    );
    if (onTap != null) {
      return GestureDetector(
        onTap: () => onTap(concepto),
        child: card
      );
    }
    return card;
  }
}
