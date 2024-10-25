import 'package:entrenador/core/entities/User.dart';

class Clase {
  String? id;
  DateTime horaInicio;
  int duracionHs;
  Usuario? alumno;
  double precio;

  Clase({
    required this.horaInicio,
    required this.duracionHs,
    this.alumno,
    required this.precio,
    this.id,
  });

  void setId(String id) {
    this.id = id;
  }

  @override
  String toString() {
    return 'Clase(id: $id, horaInicio: $horaInicio, duracionHs: $duracionHs, alumno: ${alumno?.toString() ?? 'None'}, precio: $precio)';
  }
}
