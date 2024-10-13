import 'package:entrenador/core/entities/User.dart';

class Clase {
  DateTime id;
  int duracionHs;
  Usuario? alumno;
  double precio;

  Clase({
    required this.id,
    required this.duracionHs,
    this.alumno,
    required this.precio,
  });

  @override
  String toString() {
    return 'Clase(id: $id, duracionHs: $duracionHs, alumno: ${alumno?.toString() ?? 'None'}, precio: $precio)';
  }
}