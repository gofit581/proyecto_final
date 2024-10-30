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
  Routine? actualRoutine;

  Usuario.parcial({
    this.id,
    required this.userName,
    required this.password,
    required this.mail,
    required this.age,
    required this.idTrainer,
    required this.actualSesion,
    this.actualRoutine,
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
    this.actualRoutine,
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

  //static fromJson(claseData) {}

    factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      userName: json['userName'],
      password: json['password'],
      mail: json['mail'],
      age: json['age'],
      idTrainer: json['idTrainer'],
      objectiveDescription: json['objectiveDescription'],
      experience: json['experience'],
      discipline: json['discipline'],
      trainingDays: json['trainingDays'],
      trainingDuration: json['trainingDuration'],
      injuries: json['injuries'],
      extraActivities: json['extraActivities'],
      actualRoutine: json['currentRoutine'] != null
          ? Routine.fromJson(json['currentRoutine'])
          : null,
      actualSesion: json['actualSesion'],
    );
  }

    toJson() {} 
}
