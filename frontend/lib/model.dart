import 'package:flutter/material.dart';
import 'dart:html';

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

  static Usuario fromLocalCredentials() {
    var id = int.parse(window.localStorage["usuario.id"]);
    var email = window.localStorage["usuario.email"];
    var password = window.localStorage["usuario.password"];
    var nombre = window.localStorage["usuario.nombre"];
    var apellido = window.localStorage["usuario.apellido"];
    return Usuario(id, email, password, nombre, apellido);
  }

  static localCredentialsExist() {
    return window.localStorage.containsKey("usuario.id") &&
      window.localStorage.containsKey("usuario.email") &&
      window.localStorage.containsKey("usuario.password") &&
      window.localStorage.containsKey("usuario.nombre") &&
      window.localStorage.containsKey("usuario.apellido");
  }

  static setLocalCredentials(Usuario usuario) {
    window.localStorage["usuario.id"] = usuario.id.toString();
    window.localStorage["usuario.email"] = usuario.email;
    window.localStorage["usuario.password"] = usuario.password;
    window.localStorage["usuario.nombre"] = usuario.nombre;
    window.localStorage["usuario.apellido"] = usuario.apellido;
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