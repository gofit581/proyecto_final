//quiero que me armes una screen donde cuando se vaya a ella se recibira un DateTime por parametro. al momento de renderizar quiero que tome la agenda del profesor y la renderice. la agenda la romata del UserManager. Éste le dara su atributo profesor y este atributo de dara su atrubuto agenda. La agenda es un List<Clase>. La class Clase tiene como atributos un DateTime que indicara el dia y la hora de comienzo, duracion (int) que indicara en formato de horas cuanto dura la clase, un precio(numerico) y un alumno(Usuario). Si el alumno es null, quiero que el box donde se renderizo esa clase este pintado de verde, si no es null quiero que este de rojo al rederizar. quiero que me vaya renderizando las clases una a una hacia abajo hasta terminar con todas las que coincidan con la misma fecha que fue pasada por parametro (DateTime). dame el codigo completo

import 'package:flutter/material.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/core/entities/Clase.dart';

class ClasesScreen extends StatelessWidget {
  final DateTime date;
  final userManager = UserManager();

  ClasesScreen({required this.date});

  @override
  Widget build(BuildContext context) {
    
    final profesor = userManager.profesor;
    final agenda = profesor.agenda;

    final clasesDelDia = agenda.where((clase) =>
        clase.dia.year == date.year &&
        clase.dia.month == date.month &&
        clase.dia.day == date.day).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Clases del ${date.toLocal()}'),
      ),
      body: ListView.builder(
        itemCount: clasesDelDia.length,
        itemBuilder: (context, index) {
          final clase = clasesDelDia[index];
          return Container(
            color: clase.alumno == null ? Colors.green : Colors.red,
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hora de comienzo: ${clase.dia.hour}:${clase.dia.minute}'),
                Text('Duración: ${clase.duracion} horas'),
                Text('Precio: \$${clase.precio}'),
                Text('Alumno: ${clase.alumno?.nombre ?? 'Sin asignar'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}