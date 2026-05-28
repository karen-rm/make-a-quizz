import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:makequizz/custom/form_pregunta.dart';
import 'package:makequizz/custom/form_textfiled.dart';
import 'package:makequizz/models/pregunta_model.dart';
import 'package:makequizz/services/api_service.dart';

class CreateQuizzScreen extends StatefulWidget {
  
  //Variable para determinar la acción a seguir : null = crear, número = editar
  final int? cuestionarioId; 

  const CreateQuizzScreen({super.key, this.cuestionarioId});

  @override
  State<CreateQuizzScreen> createState() => _CreateQuizzScreenState();
}

class _CreateQuizzScreenState extends State<CreateQuizzScreen> {
  
  //Variable que determina una identificador unico de cada formulario 
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  //Variable de acceso a los servicios 
  final ApiService api = ApiService();

  //Variables para recuperar los valores del formulario 
  final _tituloController = TextEditingController();
  final List<PreguntaModel> preguntas = [];
  bool loading = false;


  /* Funciones solo para modo editar */
  Future<void> cargarDatos() async {
    final data = await api.obtenerCuestionarioDetalle(widget.cuestionarioId!);

    _tituloController.text = data["titulo"];

    preguntas.clear();

    for (final p in data["preguntas"]) {
      final model = PreguntaModel(
        id: p["id"], 
        pregunta: p["pregunta"],
        correcta: p["respuesta_correcta"],
        opc1: p["opcion1"],
        opc2: p["opcion2"],
      );
      preguntas.add(model);
    }

    setState(() {});
  }

  Future<void> actualizar() async {
    final id = widget.cuestionarioId!;
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa un título")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      
      await api.actualizarCuestionario(id, titulo);

      final detalle = await api.obtenerCuestionarioDetalle(id);
      final List<dynamic> preguntasBD = detalle["preguntas"];

      final idsBD = preguntasBD.map((e) => e["id"]).toList();

      final idsDelFormulario = preguntas
          .where((p) => p.id != null)
          .map((p) => p.id)
          .toList();

      for (final idPregunta in idsBD) {
        if (!idsDelFormulario.contains(idPregunta)) {
          await api.eliminarPreguntaPorId(idPregunta);
        }
      }

      for (final p in preguntas) {
        if (p.id == null) {
          // crear una nueva
          await api.crearPregunta(
            pregunta: p.preguntaController.text.trim(),
            correcta: p.correctaController.text.trim(),
            opc1: p.opcion1Controller.text.trim(),
            opc2: p.opcion2Controller.text.trim(),
            cuestionarioId: id,
          );
        } else {
          // actualizar existente
          await api.actualizarPregunta(
            p.id!,
            pregunta: p.preguntaController.text.trim(),
            correcta: p.correctaController.text.trim(),
            opc1: p.opcion1Controller.text.trim(),
            opc2: p.opcion2Controller.text.trim(),
          );
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuestionario actualizado")),
      );

      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }
  /* Fin funciones solo para modo editar */



  /* Funciones solo para modo crear nuevo cuestionario*/
  Future<void> crear() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Ingresa un título")));
      return;
    }

    for (int i = 0; i < preguntas.length; i++) {
      final m = preguntas[i];
      if (m.preguntaController.text.trim().isEmpty ||
          m.correctaController.text.trim().isEmpty ||
          m.opcion1Controller.text.trim().isEmpty ||
          m.opcion2Controller.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Completa todos los campos de la pregunta ${i + 1}")),
        );
        return;
      }
    }

    setState(() => loading = true);

    try {
      final resCuest = await api.crearCuestionario(titulo);
      final int cuestionarioId = resCuest['id'] as int;

      for (int i = 0; i < preguntas.length; i++) {
        final m = preguntas[i];
        await api.crearPregunta(
          pregunta: m.preguntaController.text.trim(),
          correcta: m.correctaController.text.trim(),
          opc1: m.opcion1Controller.text.trim(),
          opc2: m.opcion2Controller.text.trim(),
          cuestionarioId: cuestionarioId,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cuestionario y preguntas guardados")));
      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }
  /* Fin funciones solo para modo crear nuevo cuestionario*/


  /*Funciones para ambas acciones: crear y modificar*/
  void addPregunta() {
    setState(() {
      preguntas.add(PreguntaModel());
    });
  }

  
  /*Programar el botón según la acción*/
  Future<void> submitAll() async {
    if (widget.cuestionarioId == null) {
      await crear();
    } else {
      await actualizar();

    }
  }
  /*Funciones al inicializar la pantalla según la acción a realizar*/
  @override
  void initState() {
    super.initState();
    if (widget.cuestionarioId != null) {
      cargarDatos();
    } else {
      addPregunta();
      addPregunta();
    }
  }

  /*Creación de widget principal*/
  @override
  Widget build(BuildContext context) {
    final bool esEdicion = widget.cuestionarioId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? "Editar cuestionario" : "Nuevo cuestionario"),
      ),
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(esEdicion
                  ? "Edita el nombre del cuestionario"
                  : "Ingrese el nombre del cuestionario"),
              FormularioBilderTextField(
                name: "Titulo",
                controller: _tituloController,
                width: 100,
              ),

              
              const SizedBox(height: 20),

              ...List.generate(preguntas.length, (index) {
                return PreguntaCard(
                  numero: index + 1,
                  model: preguntas[index],
                  onDelete: () {
                  setState(() {
                    preguntas[index].dispose();
                    preguntas.removeAt(index);
                  });
                },
                );
              }),

              const SizedBox(height: 10),

                TextButton(
                  onPressed: addPregunta,
                  child: const Text(
                    "+ Agregar pregunta",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),


              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : submitAll,
                child: Text(esEdicion
                    ? "Editar"
                    : "Crear cuestionario"),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
