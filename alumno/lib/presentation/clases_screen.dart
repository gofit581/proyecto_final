import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/core/entities/Clase.dart';
import 'package:alumno/core/entities/Entrenador.dart';
import 'package:alumno/core/entities/User.dart';

class ClasesScreen extends StatelessWidget {
  static const String name = 'ClasesScreen';
  final DateTime date;
  final userManager =
      UserManager(); // UserManager que gestionará el usuario actual

  ClasesScreen({required this.date});

  @override
  Widget build(BuildContext context) {
    final usuario =
        userManager.getLoggedUser(); // Obtenemos el usuario logueado
    final Entrenador? profesor =
        usuario?.getProfesor(); // Obtenemos el profesor desde el usuario
    final List<Clase> clasesDelDia = [];

    // Solo si profesor no es null y la agenda no es null, filtramos las clases
    if (profesor != null && profesor.agenda != null) {
      clasesDelDia.addAll(profesor.agenda!
          .where((clase) =>
              clase.horaInicio.year == date.year &&
              clase.horaInicio.month == date.month &&
              clase.horaInicio.day == date.day)
          .toList());
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Clases del ${date.day}/${date.month}/${date.year}',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: clasesDelDia.isNotEmpty
          ? ListView.builder(
              itemCount: clasesDelDia.length,
              itemBuilder: (context, index) {
                final clase = clasesDelDia[index];
                return Container(
                  color: clase.alumno == null ? Colors.green : Colors.red,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Hora de comienzo: ${clase.horaInicio.hour}:${clase.horaInicio.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16)),
                      Text('Duración: ${clase.duracionHs} horas',
                          style: const TextStyle(fontSize: 16)),
                      Text('Precio: \$${clase.precio}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No hay clases programadas para esta fecha.',
              ),
              // child: Text('No hay clases programadas para esta fecha.${usuario != null ? (usuario.getProfesor()?.agenda != null ? usuario.getProfesor()!.agenda![0].toString() : 'No hay agenda') : 'El profesor es null'}'),
            ),
    );
  }
}
