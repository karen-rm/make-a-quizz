import 'package:flutter/material.dart';

class PreguntaModel {
  int? id;

  final TextEditingController preguntaController;
  final TextEditingController correctaController;
  final TextEditingController opcion1Controller;
  final TextEditingController opcion2Controller;

  PreguntaModel({
    this.id,
    String? pregunta,
    String? correcta,
    String? opc1,
    String? opc2,
  })  : preguntaController = TextEditingController(text: pregunta),
        correctaController = TextEditingController(text: correcta),
        opcion1Controller = TextEditingController(text: opc1),
        opcion2Controller = TextEditingController(text: opc2);

  void dispose() {
    preguntaController.dispose();
    correctaController.dispose();
    opcion1Controller.dispose();
    opcion2Controller.dispose();
  }
}
