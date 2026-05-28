import 'package:flutter/material.dart';
import 'package:makequizz/custom/form_textfiled.dart';
import 'package:makequizz/models/pregunta_model.dart';

class PreguntaCard extends StatelessWidget {
  final int numero;
  final PreguntaModel model;
  final VoidCallback onDelete;

  const PreguntaCard({
    super.key,
    required this.numero,
    required this.model,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TÍTULO 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pregunta $numero",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// BOTÓN PARA ELIMINAR ESTA PREGUNTA
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.close, color: Colors.red),
                  )
                ],
              ),

            const SizedBox(height: 15),

            /// CAMPO DE PREGUNTA
            FormularioBilderTextField(
              name: "Pregunta",
              controller: model.preguntaController,
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            /// RESPUESTA CORRECTA
            FormularioBilderTextField(
              name: "Respuesta correcta",
              controller: model.correctaController,
            ),

            const SizedBox(height: 10),

            /// OPCIÓN 1
            FormularioBilderTextField(
              name: "Opción 1",
              controller: model.opcion1Controller,
            ),

            const SizedBox(height: 10),

            /// OPCIÓN 2
            FormularioBilderTextField(
              name: "Opción 2",
              controller: model.opcion2Controller,
            ),
          ],
        ),
      ),
      )
    );
  }
}
