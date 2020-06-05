
class Usuario {
  final String email, password, nombre, apellido;
  final int id;
  
  Usuario(this.id, this.email, this.password, this.nombre, this.apellido);

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['id'] as int,
      json['email'] as String,
      json['password'] as String,
      json['nombre'] as String,
      json['apellido'] as String,
    );
  }

  String nombreCompleto() {
    return "$nombre $apellido";
  }
}

class Concepto {

  final int id;
  final bool habilitado;
  final String nombre;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String pathImagen;
  final int usuarioId;
  final int maximaEspera;
  final int enFila;

  Concepto(
    this.id,
    this.habilitado,
    this.nombre,
    this.descripcion,
    this.latitud,
    this.longitud,
    this.pathImagen,
    this.usuarioId,
    this.maximaEspera,
    {this.enFila}
  );

  factory Concepto.fromJson(Map<String, dynamic> json) {
    return Concepto(
      json['id'] as int,
      json['habilitado'] as bool,
      json['nombre'] as String,
      json['descripcion'] as String,
      json['latitud'] as double,
      json['longitud'] as double,
      json['pathImagen'] as String,
      json['usuarioId'] as int,
      json['maximaEspera'] as int,
      enFila: json['enFila'] as int,
      );
  }
}

class Turno {

  final int id;
  final int usuarioId;
  final Usuario usuario;
  final int conceptoId;
  final Concepto concepto;
  final int numero;
  final String uuid;

  Turno(
      this.id,
      this.usuarioId,
      this.conceptoId,
      this.numero,
      this.uuid,
      {this.concepto, this.usuario});

  int get numeroToDisplay {
    return numero % 100;
  }

  factory Turno.fromJson(Map<String, dynamic> json) {
    Concepto concepto;
    if (json.containsKey('concepto')) {
      concepto = Concepto.fromJson(json['concepto']);
    }
    Usuario usuario;
    if (json.containsKey('usuario')) {
      usuario = Usuario.fromJson(json['usuario']);
    }
    return Turno(
        json['id'] as int,
        json['usuarioId'] as int,
        json['conceptoId'] as int,
        json['numero'] as int,
        json['uuid'] as String,
        concepto: concepto,
        usuario: usuario
    );
  }
}