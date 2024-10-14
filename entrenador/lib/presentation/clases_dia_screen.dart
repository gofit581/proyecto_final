//quiero que me hagas una screen(view) la cual recibira un DateTime por parametro . el trainer tendra un atributo agenda (List<Clase>). quiero que se renderice todas las clases donde coincida la fecha del DateTime pasado por parametro y la fecha de la clase(atributo id, de tipo DateTime) dentro de agenda. todas esas fechas que coincidan deberan renderizarse como un listado para poder scrollear, en caso que no quepa en la pantalla. cada box de cada clase renderizada debera ser de la siguiente manera: a la izquierda un icono de reloj. al lado el horario de la clase (tomado del atributo id de la Clase dentro de agenda). debajo de el horario, la clase tiene un atributo alumno(de tipo User), el cual puede ser null. Si alumno es null, que diga "LIBRE" (en verde claro), si el atributo no es null, que muestre el atributo "nombre" del objeto User (el alumno). Si hay alumno un boton azul que diga "IR A PERFIL"(del alumno), que al hacerle tap lleve a "perfil_alumno_screen", el cual ya estara agregado al GoRouter. mas a la derecha un icono de tacho de basura (bin) que permita borrar la Clase de la agenda.
// import 'package:entrenador/core/entities/Clase.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:entrenador/core/entities/Trainer.dart';
// import 'package:entrenador/core/entities/TrainerManager.dart';
// import 'package:entrenador/core/entities/User.dart';

// class ClasesDiaScreen extends StatelessWidget {
//   final DateTime date;
  
//   final TrainerManager manager = TrainerManager();

//   static const String name = 'ClasesDiaScreen';

//   ClasesDiaScreen({super.key, required this.date});

//   @override
//   Widget build(BuildContext context) {
//     Trainer? trainer = manager.getLoggedUser();
//     List<Clase>? clasesDelDia = trainer?.agenda
//         !.where((clase) => clase.id.year == date.year && clase.id.month == date.month && clase.id.day == date.day)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Clases del Día'),
//       ),
//       body: ListView.builder(
//         itemCount: clasesDelDia?.length,
//         itemBuilder: (context, index) {
//           Clase clase = clasesDelDia![index];
//           return ListTile(
//             leading: Icon(Icons.access_time),
//             title: Text('${clase.id.hour}:${clase.id.minute.toString().padLeft(2, '0')}'),
//             subtitle: clase.alumno == null
//                 ? Text('LIBRE', style: TextStyle(color: Colors.green))
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(clase.alumno!.userName),
//                       ElevatedButton(
//                         onPressed: () {
//                           context.go('/perfil_alumno_screen', extra: clase.alumno);
//                         },
//                         child: Text('IR A PERFIL'),
//                       ),
//                     ],
//                   ),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 // Implement delete functionality here
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:entrenador/core/entities/Clase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';

class ClasesDiaScreen extends StatelessWidget {
  final DateTime date;
  final TrainerManager manager = TrainerManager();

  static const String name = 'ClasesDiaScreen';

  ClasesDiaScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    // Obtener el Trainer logueado
    Trainer? trainer = manager.getLoggedUser();

    // Filtrar las clases que coincidan con la fecha seleccionada
    List<Clase> clasesDelDia = trainer?.agenda
            ?.where((clase) =>
                clase.id.year == date.year &&
                clase.id.month == date.month &&
                clase.id.day == date.day)
            .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Clases del Día'),
      ),
      body: clasesDelDia.isEmpty
          ? Center(
              child: Text(
                'No hay clases programadas para este día. ' 
                // + (trainer?.agenda?.toString() ?? "agenda de " + trainer!.userName+ " es null. ----"
                // + clasesDelDia.toString())
                ,
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
                    '${clase.id.hour}:${clase.id.minute.toString().padLeft(2, '0')}',
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
                      _eliminarClase(context, trainer, clase);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _eliminarClase(BuildContext context, Trainer? trainer, Clase clase) {
    if (trainer != null) {
      trainer.agenda?.remove(clase);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Clase eliminada de la agenda.'),
          duration: Duration(seconds: 2),
        ),
      );
      // Se podría agregar lógica para actualizar la base de datos o el estado global de la aplicación si es necesario
    }
  }
}