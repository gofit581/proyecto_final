import 'package:entrenador/core/entities/Clase.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';

class ClasesDiaScreen extends StatefulWidget {
  final DateTime date;

  static const String name = 'ClasesDiaScreen';

  const ClasesDiaScreen({super.key, required this.date});

  @override
  // ignore: library_private_types_in_public_api
  _ClasesDiaScreenState createState() => _ClasesDiaScreenState();
}

class _ClasesDiaScreenState extends State<ClasesDiaScreen> {
  final TrainerManager manager = TrainerManager();
  List<Clase> clasesDelDia = [];

  @override
  void initState() {
    super.initState();
    _loadClasesDelDia();
  }

  void _loadClasesDelDia() {
    Trainer? trainer = manager.getLoggedUser();
    setState(() {
      clasesDelDia = trainer?.agenda
              ?.where((clase) =>
                  clase.horaInicio.year == widget.date.year &&
                  clase.horaInicio.month == widget.date.month &&
                  clase.horaInicio.day == widget.date.day)
              .toList() ??
          [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Clases del Día',
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: clasesDelDia.isEmpty
          ? Center(
              child: Text(
                'No hay clases programadas para este día.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            )
          : ListView.builder(
              itemCount: clasesDelDia.length,
              itemBuilder: (context, index) {
                Clase clase = clasesDelDia[index];
                return ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(
                    '${clase.horaInicio.hour}:${clase.horaInicio.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: clase.alumno == null
                      ? const Text(
                          'LIBRE',
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clase.alumno!.userName,
                              style: const TextStyle(fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Navegar al perfil del alumno usando GoRouter
                                context.go('/perfil_alumno_screen', extra: clase.alumno);
                              },
                              // ignore: sort_child_properties_last
                              child: const Text('IR A PERFIL'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implementar funcionalidad para eliminar la clase
                      _eliminarClase(context, clase);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _eliminarClase(BuildContext context, Clase clase) {
    Trainer? trainer = manager.getLoggedUser();
    if (trainer != null) {
      manager.borrarClaseId(clase);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clase eliminada de la agenda.'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        clasesDelDia.remove(clase); // Actualizar la lista de clases
      });
    }
  }
}
