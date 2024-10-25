import 'package:entrenador/core/entities/Clase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';

class ClasesDiaScreen extends StatefulWidget {
  final DateTime date;

  static const String name = 'ClasesDiaScreen';

  ClasesDiaScreen({super.key, required this.date});

  @override
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
      appBar: AppBar(
        title: Text('Clases del Día'),
      ),
      body: clasesDelDia.isEmpty
          ? Center(
              child: Text(
                'No hay clases programadas para este día.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: clasesDelDia.length,
              itemBuilder: (context, index) {
                Clase clase = clasesDelDia[index];
                return ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text(
                    '${clase.horaInicio.hour}:${clase.horaInicio.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: clase.alumno == null
                      ? Text(
                          'LIBRE',
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clase.alumno!.userName,
                              style: TextStyle(fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Navegar al perfil del alumno usando GoRouter
                                context.go('/perfil_alumno_screen', extra: clase.alumno);
                              },
                              child: Text('IR A PERFIL'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                textStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
        SnackBar(
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
