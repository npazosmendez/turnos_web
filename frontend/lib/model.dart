
class Usuario {
  final String email, password;
  final int id;
  
  Usuario(this.id, this.email, this.password);

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['id'] as int,
      json['email'] as String,
      json['password'] as String);
  }
}

class Concepto {

  final bool habilitado;
  final String nombre;
  final String descripcion;
  final double latitud;
  final double longitud;

  Concepto(
    this.habilitado,
    this.nombre,
    this.descripcion,
    this.latitud,
    this.longitud);

  factory Concepto.fromJson(Map<String, dynamic> json) {
    return Concepto(
      json['habilitado'] as bool,
      json['nombre'] as String,
      json['descripcion'] as String,
      json['latitud'] as double,
      json['longitud'] as double);
  }
}

