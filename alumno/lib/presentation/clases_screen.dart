import 'package:flutter/material.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/core/entities/Clase.dart';
import 'package:alumno/core/entities/Entrenador.dart';
import 'package:alumno/core/entities/User.dart';

/////////////////////////////////////////////////////////////////// TESTING PACK
// Simulamos algunos entrenadores para los usuarios

// Creamos los usuarios con sus respectivos atributos
// Usuario alumno1 = Usuario(
//   id: '1',
//   userName: 'JuanPerez',
//   password: 'password123',
//   mail: 'juan.perez@example.com',
//   age: '25',
//   idTrainer: '123',
//   objectiveDescription: 'Perder peso',
//   experience: 'Intermedio',
//   discipline: 'CrossFit',
//   trainingDays: 'Lunes, Miércoles, Viernes',
//   trainingDuration: '1 hora',
//   injuries: 'Ninguna',
//   extraActivities: 'Ciclismo',
// );

// Usuario alumno2 = Usuario(
//   id: '2',
//   userName: 'AnaGarcia',
//   password: 'password456',
//   mail: 'ana.garcia@example.com',
//   age: '28',
//   idTrainer: '124',
//   objectiveDescription: 'Ganar masa muscular',
//   experience: 'Principiante',
//   discipline: 'Levantamiento de pesas',
//   trainingDays: 'Martes, Jueves, Sábado',
//   trainingDuration: '1 hora y media',
//   injuries: 'Lesión en la rodilla',
//   extraActivities: 'Yoga',
// );

// // Generamos una lista de clases con fechas desde el 27/9/2024 hasta dentro de un mes
// List<Clase> generarAgenda() {
//   List<Clase> agenda = [];
//   DateTime fechaInicio = DateTime(2024, 9, 27);

//   for (int i = 0; i < 30; i++) {
//     DateTime fechaClase = fechaInicio.add(Duration(days: i));

//     // Generar 10 clases por día, empezando a las 10:00 am
//     for (int j = 0; j < 10; j++) {
//       DateTime horarioClase = DateTime(
//         fechaClase.year,
//         fechaClase.month,
//         fechaClase.day,
//         10 + j, // Clase de 10am, 11am, ..., 7pm
//       );

//       agenda.add(Clase(
//         id: horarioClase,
//         duracionHs: 1, // Todas las clases duran 1 hora
//         alumno: j % 2 == 0
//             ? null
//             : (j % 3 == 0
//                 ? alumno1
//                 : alumno2), // Alternamos entre clases sin alumno, con Juan o con Ana
//         precio: 50 + (j % 3) * 10, // Precio variado por clase
//       ));
//     }
//   }
//   return agenda;
// }

// // Creamos un objeto Entrenador con la agenda generada
// Entrenador entrenadorHardcodeado = Entrenador(
//   id: '123',
//   nombre: 'Carlos',
//   apellido: 'Rodríguez',
//   alumnos: ['Juan', 'Ana'],
//   agenda: generarAgenda(),
//   rutinas: [], // No se están utilizando rutinas en este ejemplo
//   ejercicios: [], // No se están utilizando ejercicios en este ejemplo
// );

///////////////////////////////////////////////////////////////

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
      appBar: AppBar(
        title: Text('Clases del ${date.day}/${date.month}/${date.year}'),
      ),
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
                          'Hora de comienzo: ${clase.horaInicio.hour}:${clase.horaInicio.minute}',
                          style: TextStyle(fontSize: 16)),
                      Text('Duración: ${clase.duracionHs} horas',
                          style: TextStyle(fontSize: 16)),
                      Text('Precio: \$${clase.precio}',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'No hay clases programadas para esta fecha. ${profesor != null ? profesor.toString() : 'no hay profesor'}',
              ),
              // child: Text('No hay clases programadas para esta fecha.${usuario != null ? (usuario.getProfesor()?.agenda != null ? usuario.getProfesor()!.agenda![0].toString() : 'No hay agenda') : 'El profesor es null'}'),
            ),
    );
  }
}


