import 'package:flutter/material.dart';

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
            Container(
              height: 200,
              width: 100,
              child: Image.network(
                getImageUrl(),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                child: Text(
                  concepto.nombre,
                  style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                )
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Text(
                  concepto.descripcion,
                  style: TextStyle(fontSize: 15),
                )
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Row(
                  children: <Widget> [
                    Text(
                      concepto.maximaEspera != null ? "${concepto.enFila}/${concepto.maximaEspera}" : concepto.enFila.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.person)
                  ]
                ),
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
