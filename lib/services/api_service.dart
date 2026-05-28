import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://web-production-52650.up.railway.app";

  final Map<String, String> _headers = {"Content-Type": "application/json"};

  //Crear cuestionario 
  Future<Map<String, dynamic>> crearCuestionario(String titulo) async {
    final url = Uri.parse("$baseUrl/cuestionario");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"titulo": titulo}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al crear cuestionario: ${response.body}");
    }
  }

  //Crear pregunta 
  Future<Map<String, dynamic>> crearPregunta({
    required String pregunta,
    required String correcta,
    required String opc1,
    required String opc2,
    required int cuestionarioId,
  }) async {
    final url = Uri.parse("$baseUrl/pregunta");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "pregunta": pregunta,
        "correcta": correcta,
        "opc1": opc1,
        "opc2": opc2,
        "cuestionario_id": cuestionarioId,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al crear pregunta: ${response.body}");
    }
  }

  //obtener lista de cuestionarios 
  Future<List<dynamic>> obtenerCuestionarios() async {
    final url = Uri.parse("$baseUrl/cuestionarios");

    final res = await http.get(url, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception("Error al obtener cuestionarios: ${res.body}");
    }

    final data = jsonDecode(res.body);

    if (data is List) {
      return data;
    } else {
      throw Exception("La respuesta no es una lista válida");
    }
  }

  //obtener lista de preguntas 
  Future<List<dynamic>> obtenerPreguntas(int cuestionarioId) async {
    final url = Uri.parse("$baseUrl/preguntas/$cuestionarioId");

    final res = await http.get(url, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception("Error al obtener preguntas: ${res.body}");
    }

    final data = jsonDecode(res.body);

    if (data is List) {
      return data;
    } else {
      throw Exception("La respuesta no es una lista válida");
    }
  }

  //eliminar cuestionario + sus preguntas 
  Future<void> eliminarCuestionarioCompleto(int cuestionarioId) async {
    final url = Uri.parse("$baseUrl/cuestionario_completo/$cuestionarioId");

    final response = await http.delete(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
        "Error al eliminar cuestionario completo: ${response.body}",
      );
    }
  }

  //obtener datos de estadisticas de aprobados (cuestionario)
  Future<Map<String, dynamic>> obtenerEstadisticasAprobados() async {
    final url = Uri.parse("$baseUrl/estadisticas/aprobados");

    final res = await http.get(url, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception("Error al obtener estadísticas de aprobados: ${res.body}");
    }

    final data = jsonDecode(res.body);

    if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw Exception("La respuesta no es un JSON válido");
    }
  }

  //obtener estadisticas para un cuestionario de puntajes y tiempo
  Future<Map<String, dynamic>> obtenerEstadisticasPorNombre(String nombreCuestionario) async {
    final url = Uri.parse("$baseUrl/estadisticas/alumno/$nombreCuestionario");

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Cuestionario no encontrado");
    } else {
      throw Exception("Error al obtener estadísticas: ${response.body}");
    }
  }

  //actualizar info de cuestioanrio 
  Future<Map<String, dynamic>> actualizarCuestionario(
      int cuestionarioId,
      String nuevoTitulo,
    ) async {
    final url = Uri.parse("$baseUrl/cuestionario/$cuestionarioId");

    final res = await http.put(
      url,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({"titulo": nuevoTitulo}),
    );

    if (res.statusCode != 200) {
      throw Exception("Error al actualizar cuestionario: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  //actualizar info de una pregunta 
  Future<void> actualizarPregunta(
    int idPregunta, {
    required String pregunta,
    required String correcta,
    required String opc1,
    required String opc2,
  }) async {
    final url = Uri.parse("$baseUrl/pregunta/$idPregunta");

    final body = {
      "pregunta": pregunta,
      "correcta": correcta,
      "opcion1": opc1,
      "opcion2": opc2,
    };

    final res = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception("Error actualizando la pregunta: ${res.body}");
    }
  }

  //obtener info cuestionario + info de sus preguntas asociadas 
  Future<Map<String, dynamic>> obtenerCuestionarioDetalle(int id) async {
    final url = Uri.parse("$baseUrl/cuestionario/$id/detalle");

    final res = await http.get(url, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception("Error al obtener detalles: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  //eliminar una pregunta con su id 
  Future<void> eliminarPreguntaPorId(int idPregunta) async {
    final url = Uri.parse("$baseUrl/pregunta/$idPregunta");

    final res = await http.delete(url);

    if (res.statusCode != 200) {
      throw Exception("Error al eliminar la pregunta: ${res.body}");
    }
  }

  Future<List<dynamic>> obtenerResultadosPorCuestionario(int idCuestionario) async {
  final url = Uri.parse("$baseUrl/alumnos/cuestionario/$idCuestionario");
  final res = await http.get(url);

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw Exception("Error al obtener resultados por cuestionario");
  }
}



}
