import 'package:flutter/material.dart';
import '../model.dart' as model;

class Fila extends StatelessWidget {
  final Future<List<model.Turno>> futureTurnos;
  final Function(model.Turno) onAtenderSiguiente;
  final Function(model.Turno) onScanQrSiguiente;

  Fila({this.futureTurnos, this.onAtenderSiguiente, this.onScanQrSiguiente});

  Widget botonConIcon(Icon icon, Function callback) {
    return SizedBox.fromSize(
      size: Size(40, 40),
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
    Color mainColor = siguiente ? Colors.black : Colors.black54;
    var columnas = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              turno.usuario.nombreCompleto(),
              style: TextStyle(
                color: mainColor,
                fontSize: 18,
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(turno.numero.toString(), style: TextStyle(fontSize: 25, color: mainColor, fontWeight: FontWeight.bold)),
      )

    ];

    if(siguiente) {
      columnas.addAll(<Widget>[
        botonConIcon(
          Icon(Icons.camera_alt, size: 30, color: Colors.black54),
          () => onScanQrSiguiente(turno),
        ),
        botonConIcon(
          Icon(Icons.navigate_next, size: 30, color: Colors.blue),
          () => onAtenderSiguiente(turno),
        ),
      ]);
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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