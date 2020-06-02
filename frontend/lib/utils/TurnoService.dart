import 'dart:convert';

import 'package:frontend/utils/apiclient.dart';

import '../model.dart';

class TurnoService {

  final ApiClient apiClient;
  final String baseUrl = "/turnos";

  TurnoService(this.apiClient);

  Future<List<Turno>> query(queryParameters) async {
    var response = await apiClient.get(baseUrl, queryParameters: queryParameters);

    Iterable conceptosJson = json.decode(response.body);
    return List<Turno>.from(
        conceptosJson.map((json) => Turno.fromJson(json))
    );
  }

  Future<Turno> create(Concepto concepto) async {
    var response = await apiClient.postJson(baseUrl, {
      "conceptoId": concepto.id
    });
    var turnoJson = json.decode(response.body);
    return Turno.fromJson(turnoJson);
  }
}