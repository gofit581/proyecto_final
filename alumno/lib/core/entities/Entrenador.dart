import 'package:alumno/core/entities/Clase.dart';
import 'package:alumno/core/entities/Exercise.dart';
import 'package:alumno/core/entities/Routine.dart';

class Entrenador {
  final String? id;
  String nombre;
  String apellido;
  List<String>? alumnos;
  List<Clase>? agenda;
  List<Routine>? rutinas;
  List<Exercise>? ejercicios;

  Entrenador({
    this.id,
    this.nombre = 'Nombre no disponible',
    this.apellido = 'Apellido no disponible',
    this.alumnos = const [],
    this.agenda = const [],
    this.rutinas = const [],
    this.ejercicios = const [],
  });

  Entrenador.full({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.alumnos,
    required this.agenda,
    required this.rutinas,
    required this.ejercicios,
  });

  @override
  String toString() {
    return '$nombre $apellido';
  }

  String getNombre() {
    return nombre;
  }

  void setNombre(String nombre) {
    this.nombre = nombre;
  }

  String getApellido() {
    return apellido;
  }

  void setApellido(String apellido) {
    this.apellido = apellido;
  }

  List<String>? getAlumnos() {
    return alumnos;
  }

  void setAlumnos(List<String> alumnos) {
    this.alumnos = alumnos;
  }

  List<Clase>? getAgenda() {
    return agenda;
  }

  void setAgenda(List<Clase> agenda) {
    this.agenda = agenda;
  }
}
