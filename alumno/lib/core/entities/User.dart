import 'package:alumno/core/entities/Entrenador.dart';
import 'package:alumno/core/entities/Routine.dart';

class Usuario {
  final String? id;
  String userName;
  String password;
  String mail;
  String age;
  String idTrainer;
  String? objectiveDescription;
  String? experience;
  String? discipline;
  String? trainingDays;
  String? trainingDuration;
  String? injuries;
  String? extraActivities;
  Entrenador? profesor;
  int actualSesion;
  late Routine actualRoutine;

  Usuario.parcial({
    this.id,
    required this.userName,
    required this.password,
    required this.mail,
    required this.age,
    required this.idTrainer,
    required this.actualSesion
  });

  Usuario({
    this.id,
    required this.userName,
    required this.password,
    required this.mail,
    required this.age,
    required this.idTrainer,
    required this.objectiveDescription,
    required this.experience,
    required this.discipline,
    required this.trainingDays,
    required this.trainingDuration,
    required this.injuries,
    required this.extraActivities, 
    required this.actualSesion,
  });

  set entrenador(Future<Entrenador> entrenador) {}

  @override
  String toString() {
    return userName;
  }

  String getEmail() {
    return mail;
  }

  String getAge() {
    return age;
  }

  Entrenador? getProfesor() {
    return profesor;
  }

  void setUserName(String name) {
    userName = name;
  }

  void setProfesor(Entrenador profesor) {
    profesor = profesor;
  }

  void setAge(String edad) {
    age = edad;
  }

  void setEmail(String email) {
    mail = email;
  }

  static fromJson(claseData) {}
}
