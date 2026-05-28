import 'package:flutter/material.dart';
import 'package:makequizz/screens/new_quizz.dart';
import 'package:makequizz/screens/preguntas_screen.dart';
import 'package:makequizz/services/api_service.dart';

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({super.key});

  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {

  //Variable global para acceder a los servicios 
  final ApiService api = ApiService();

  //Variables para la sección cuestionarios 
  List<dynamic> cuestionarios = [];
  bool loading = false;
  List<dynamic> preguntas = [];

  //Variables para el cambio de sección: Por defecto sección cuestionarios activa
  List<bool> isSelected = [true, false]; 
  int currentIndex = 0; 

  //Variables para la sección estadisticas 
  List<dynamic> listaCuestionarios = [];
  String? cuestionarioSeleccionado;
  Map<String, dynamic>? estadisticas;

  List<dynamic> resultadosAlumnos = [];

  /*Funciones para la sección cuestionarios */
  Future<void> mostrarCuestionarios() async {
    setState(() => loading = true);

    try {
      final res = await api.obtenerCuestionarios();
      setState(() {
        cuestionarios = res;
      });
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> mostrarPreguntas(int cuestionarioId) async {
    setState(() => loading = true);

    try {
      final res = await api.obtenerPreguntas(cuestionarioId);
      setState(() {
        preguntas = res; 
      });
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }
  /*Fin funciones para la sección cuestionarios */


  /*Funciones para la sección estadisticas*/
  Future<void> cargarCuestionarios() async {
    try {
      final data = await api.obtenerCuestionarios();
      setState(() {
        listaCuestionarios = data;
      });
    } catch (e) {
      debugPrint("Error cargando cuestionarios: $e");
    }
  }

  Future<void> cargarEstadisticas(String nombreCuestionario) async {
    setState(() {
      estadisticas = null;
      resultadosAlumnos = [];
    });

    try {
      // Buscar el cuestionario en la lista para obtener su id
      final item = listaCuestionarios.firstWhere(
        (c) => c["titulo"] == nombreCuestionario,
      );

      final int idCuestionario = item["id"];

      // 1. Estadísticas
      final dataEstadisticas =
          await api.obtenerEstadisticasPorNombre(nombreCuestionario);

      // 2. Resultados de alumnos
      final dataResultados =
          await api.obtenerResultadosPorCuestionario(idCuestionario);

      setState(() {
        estadisticas = dataEstadisticas;
        resultadosAlumnos = dataResultados; // <---- NUEVO
      });
    } catch (e) {
      //print("Error al cargar estadísticas: $e");
    }
  }

  /*Fin funciones para la sección estadisticas*/

  
  //Métodos al incializar la pantalla 
  @override
  void initState() {
    super.initState();
    mostrarCuestionarios();
    cargarCuestionarios();
  }

  //Construcción del widget principal 
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Make a Quizz || Karen rmz - Yuliana csnv",
          style: textTheme.titleMedium,
        ),
        backgroundColor: const Color.fromARGB(255, 17, 59, 107),
      ),
      body: Column(
        children: [
          // Toggle Buttons
          ToggleButtons(
            isSelected: isSelected,
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = (i == index);
                }
                currentIndex = index;
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55),
                child: Text("Cuestionarios"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55),
                child: Text("Estadísticas"),
              ),
            ],
          ),
          // Fin Toggle Buttons

          const SizedBox(height: 20),

          /* Contenido por sección */
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: [
              
               /*SECCIÓN 1: CUESTIONARIOS */
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('  Mis cuestionarios', style: textTheme.titleLarge),
                        ElevatedButton(
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CreateQuizzScreen()),
                            );
                            
                            if (updated == true) {
                              mostrarCuestionarios(); 
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: const Color.fromARGB(255, 17, 59, 107), 
                            foregroundColor: Colors.white, 
                            elevation: 4,
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),


                    const SizedBox(height: 15),
                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: cuestionarios.length,
                        itemBuilder: (context, index) {
                          final item = cuestionarios[index];
                          return ListTile(
                            title: Text("${item["titulo"]}"),
                            subtitle: Text("Código: ${item["codigo"]}"),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value)  async {
                                switch (value) {
                                  case 'ver':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PreguntasScreen(
                                            cuestionarioId: item["id"]),
                                      ),
                                    );
                                    break;

                                  case 'modificar':
                                    final updatedM = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CreateQuizzScreen(
                                          cuestionarioId: item['id'],
                                        ),
                                      ),
                                    );
                                    if (updatedM == true) {
                                      mostrarCuestionarios(); 
                                    }
                                    break;

                                  case 'eliminar':
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Eliminar cuestionario"),
                                        content: Text(
                                            "¿Deseas eliminar este cuestionario y todas sus preguntas?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final navigator =
                                                  Navigator.of(context);
                                              final messenger =
                                                  ScaffoldMessenger.of(context);

                                              navigator.pop();

                                              try {
                                                await api.eliminarCuestionarioCompleto(
                                                    item["id"]);

                                                messenger.showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Cuestionario eliminado")));

                                                mostrarCuestionarios();
                                              } catch (e) {
                                                messenger.showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Error al eliminar: $e")));
                                              }
                                            },
                                            child: Text("Eliminar",
                                                style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'ver',
                                  child: Text('Ver preguntas'),
                                ),
                                PopupMenuItem(
                                  value: 'modificar',
                                  child: Text('Modificar'),
                                ),
                                PopupMenuItem(
                                  value: 'eliminar',
                                  child: Text('Eliminar'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                /*FIN SECCIÓN 1: CUESTIONARIOS */


                /*SECCIÓN 2: ESTADÍSTICAS */
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Estadísticas generales", style: textTheme.titleLarge),
                      const SizedBox(height: 20),

                      /* estadisticas aprobados*/
                      FutureBuilder(
                        future: api.obtenerEstadisticasAprobados(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          }

                          final data = snapshot.data as Map<String, dynamic>;
                          return buildCardsEstadisticas(data);
                        },
                      ),
                      /* fin estadisticas aprobados*/

                      const SizedBox(height: 35),
                      Divider(),
                      const SizedBox(height: 20),

                      // dropdown de cuestionarios
                      Text("Estadísticas por cuestionario", style: textTheme.titleLarge),
                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Selecciona un cuestionario",
                        ),
                        style: const TextStyle(
                          color: Colors.black,        
                          fontSize: 16,
                        ),
                        initialValue: cuestionarioSeleccionado,
                        items: listaCuestionarios.map<DropdownMenuItem<String>>((c) {
                          return DropdownMenuItem<String>(
                            value: c["titulo"].toString(),      
                            child: Text(c["titulo"].toString()), 
                          );
                        }).toList(),
                        onChanged: (valor) {
                          setState(() => cuestionarioSeleccionado = valor);
                          if (valor != null) cargarEstadisticas(valor);
                        },
                      ),
                      // Fin dropdown de cuestionarios

                      const SizedBox(height: 25),

                      /*estadisticas calificación y tiempo*/
                      if (estadisticas == null)
                        Center(child: Text("Selecciona un cuestionario para ver las estadísticas."))
                      else
                        Column(
                          children: [
                            _buildEstadisticaCard(
                              titulo: "Mayor Puntaje",
                              dato: estadisticas!["alumno_mayor_puntaje"],
                              icono: Icons.arrow_upward,
                              color: Colors.green,
                            ),
                            _buildEstadisticaCard(
                              titulo: "Menor Puntaje",
                              dato: estadisticas!["alumno_menor_puntaje"],
                              icono: Icons.arrow_downward,
                              color: Colors.red,
                            ),
                            _buildEstadisticaCard(
                              titulo: "Mayor Tiempo",
                              dato: estadisticas!["alumno_mayor_tiempo"],
                              icono: Icons.timer,
                              color: Colors.orange,
                            ),
                            _buildEstadisticaCard(
                              titulo: "Menor Tiempo",
                              dato: estadisticas!["alumno_menor_tiempo"],
                              icono: Icons.timelapse,
                              color: Colors.blue,
                            ),
                          ],
                        ),

                        if (resultadosAlumnos.isNotEmpty) ...[
                          const SizedBox(height: 30),
                          Text("Alumnos que realizaron este cuestionario",
                              style: textTheme.titleLarge),
                          const SizedBox(height: 15),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: resultadosAlumnos.length,
                            itemBuilder: (context, index) {
                              final r = resultadosAlumnos[index];

                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(r["nombre"]),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Puntaje: ${r["puntaje"]}"),
                                      Text("Inicio: ${r["tiempo_inicio"]}"),
                                      Text("Fin: ${r["tiempo_final"]}"),
                                      Text("Aprobado: ${r["aprobado"] ? "Sí" : "No"}"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ]
                        else if (estadisticas != null) ...[
                          const SizedBox(height: 20),
                          Text("Nadie ha realizado este cuestionario aún.",
                              style: TextStyle(color: Colors.grey)),
                        ]

                    ],
                  ),
                ),
                /*FIN SECCIÓN 2: ESTADÍSTICAS */
  
              ],
            ),
          ),
          /*Fin contenido por sección */
        ],
      ),
    );
  } //Fin construcción del widget principal 
}//Fin class screenQuizzState


//Widget para cards para estadisticas aprobados 
Widget buildCardsEstadisticas(Map<String, dynamic> data) {
  final mas = data["cuestionario_mas_aprobados"];
  final menos = data["cuestionario_menos_aprobados"];

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        const Text(
          "Estadísticas de Aprobados",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        // CARD: MÁS APROBADOS
        Card(
          elevation: 4,
          color: const Color.fromARGB(255, 17, 59, 107),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cuestionario con más aprobados",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text("Nombre: ${mas["nombre"] ?? "Sin datos"}",
                  style: TextStyle(color: Colors.white),),
                Text("Aprobados: ${mas["total_aprobados"] ?? 0}",
                  style: TextStyle(color: Colors.white),),
                Text("Respuestas totales: ${mas["total_respuestas"] ?? 0}",
                  style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // CARD: MENOS APROBADOS
        Card(
          elevation: 4,
          color: const Color.fromARGB(255, 17, 59, 107),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cuestionario con menos aprobados",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text("Nombre: ${menos["nombre"] ?? "Sin datos"}",
                  style: TextStyle(color: Colors.white),),
                Text("Aprobados: ${menos["total_aprobados"] ?? 0}", 
                  style: TextStyle(color: Colors.white),),
                Text("Respuestas totales: ${menos["total_respuestas"] ?? 0}",
                  style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


//Widget para cards para estadisticas 
Widget _buildEstadisticaCard({
  required String titulo,
  required Map<String, dynamic>? dato,
  required IconData icono,
  required Color color,
}) {
  if (dato == null) return const SizedBox();

  return Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icono, size: 40, color: color),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text("Nombre: ${dato["nombre"] ?? "Sin datos"}"),
                Text("Puntaje: ${dato["puntaje"] ?? "N/A"}"),
                if (dato.containsKey("duracion"))
                  Text("Duración: ${dato["duracion"]} s"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
