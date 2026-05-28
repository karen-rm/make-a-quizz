import 'package:flutter/material.dart';
import 'package:makequizz/services/api_service.dart';

class PreguntasScreen extends StatefulWidget {
  final int cuestionarioId;
  const PreguntasScreen({super.key, required this.cuestionarioId});

  @override
  State<PreguntasScreen> createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen> {
  List<dynamic> preguntas = [];
  bool loading = true;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    try {
      final res = await api.obtenerPreguntas(widget.cuestionarioId);
      setState(() {
        preguntas = res;
      });
    } catch (e) {
      //print("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: Text("Preguntas")),
      body: ListView.builder(
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          final item = preguntas[index];
          return ListTile(
            title: Text("${index + 1}. ${item["pregunta"]}"),
            subtitle: Text(
              "1) ${item["opcion1"]}\n2) ${item["opcion2"]}\nCorrecta: ${item["respuesta_correcta"]}"
            ),
          );
        },
      ),
    );
  }
}
