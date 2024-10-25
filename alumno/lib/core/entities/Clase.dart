import 'package:alumno/core/entities/User.dart';

class Clase {
  String id;
  DateTime horaInicio;
  int duracionHs;
  Usuario? alumno;
  double precio;

  Clase({
    required this.id,
    required this.duracionHs,
    this.alumno,
    required this.precio,
    required this.horaInicio,
  });

  @override
  String toString() {
    return 'Clase(id: $id, horaInicio: $horaInicio, duracionHs: $duracionHs, alumno: ${alumno?.toString() ?? 'None'}, precio: $precio)';
  }
}
