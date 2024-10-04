import 'package:entrenador/core/entities/User.dart';

class Clase {
  DateTime id;
  double duracionHs;
  double precio;
  Usuario? alumno;

  Clase({
    required this.id,
    required this.duracionHs,
    required this.precio,
    this.alumno,
  });
}