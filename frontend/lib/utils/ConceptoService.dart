import 'dart:convert';

import 'package:frontend/utils/apiclient.dart';
import 'package:frontend/utils/file_picker.dart';
import 'package:http/http.dart';

import '../model.dart';

class ConceptoService {

  final ApiClient apiClient;
  final String baseUrl = "/conceptos";

  ConceptoService(this.apiClient);

  Future<List<Concepto>> query(queryParameters) async {
    var response = await apiClient.get(baseUrl, queryParameters: queryParameters);

    Iterable conceptosJson = json.decode(response.body);
    return List<Concepto>.from(
        conceptosJson.map((json) => Concepto.fromJson(json))
    );
  }

  Future<Concepto> get(int id) async {
    // TODO reemplazar por endpoint /conceptos/:id/ (no esta en backend)
    var response = await apiClient.get(baseUrl, queryParameters: {"id": id.toString()});
    Iterable conceptosJson = json.decode(response.body);
    return Concepto.fromJson(conceptosJson.first);
  }

  Future<Concepto> create(String nombre, String descripcion, int maximaEspera, {int latitud = 0, int longitud = 0}) async {
    var response = await apiClient.postJson(baseUrl, {
      "nombre": nombre,
      "descripcion": descripcion,
      "latitud": latitud,
      "longitud": longitud,
      "maximaEspera": maximaEspera, // Datazo: los ints son nulleables
    });
    Map<String, dynamic> conceptosJson = json.decode(response.body);
    return Concepto.fromJson(conceptosJson);
  }

  Future<Concepto> subirImagen(Concepto concepto, PickedFile img) async {
    var multipartFile = MultipartFile.fromBytes(
        "imagen_concepto",
        img.data,
        filename: img.name);

    var response = await apiClient.postMultipartFile("$baseUrl/${concepto.id}/asociar_imagen", multipartFile);
    var conceptosJson = json.decode(await response.stream.bytesToString());
    return Concepto.fromJson(conceptosJson);
  }
}