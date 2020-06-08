import 'package:flutter/material.dart';
import '../model.dart' as model;

class Fila extends StatelessWidget {
  final Future<List<model.Turno>> futureTurnos;
  final Function(model.Turno) onCancelSiguiente;
  final Function(model.Turno) onScanQrSiguiente;

  Fila({this.futureTurnos, this.onCancelSiguiente, this.onScanQrSiguiente});

  Widget botonConIcon(Icon icon, Function callback) {
    return SizedBox.fromSize(
      size: Size(100, 100),
      child: ClipOval(
        child: Material(
          child: InkWell(
            hoverColor: Color.fromRGBO(0, 0, 0, 0.1),
            onTap: callback,
            child: icon,
          ),
        ),
      ),
    );
  }

  Widget turnoEnFila(model.Turno turno, bool siguiente) {
    // Si siguiente=true, se muestran más opciones y cambian algunos estilos
    var columnas = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              turno.usuario.nombreCompleto(),
              style: TextStyle(
                color: siguiente ? Colors.black : Colors.black54,
                fontSize: siguiente ? 30 : 18,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              turno.usuario.email,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(turno.numero.toString(), style: TextStyle(fontSize: siguiente ? 40 : 25, fontWeight: FontWeight.bold)),
      ),
    ];

    if(siguiente) {
      columnas.addAll(<Widget>[
        botonConIcon(
          Icon(Icons.camera_alt, size: 50, color: Colors.black54),
          () => onScanQrSiguiente(turno),
        ),
        botonConIcon(
          // Otras opciones: delete, block
          Icon(Icons.clear, size: 50, color: Colors.red[900]),
          () => onCancelSiguiente(turno),
        ),
      ]);
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          children: columnas,
        ),
      ),
    );
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<model.Turno>>(
        future: futureTurnos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              snapshot.data.sort((t1,t2) => t1.numero.compareTo(t2.numero));
              // El próximo cliente se muestra distinto
              List<Widget> turnosEnFila = snapshot.data.sublist(1).map((t) => this.turnoEnFila(t, false)).toList();
              turnosEnFila.insert(0, this.turnoEnFila(snapshot.data[0], true));
              return new Expanded(
                  child: ListView(
                      padding: EdgeInsets.all(5),
                      children: turnosEnFila,
                  )
              );
            } else {
              return Center(
                child: Text(
                  "No hay clientes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              );
            }
          } else if (snapshot.hasError) {
            // TODO
            print(snapshot.error);
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}