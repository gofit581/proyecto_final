import 'package:alumno/core/entities/Entrenador.dart';

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

  
  Usuario.parcial(
      {
      this.id,
      required this.userName,
      required this.password,
      required this.mail,
      required this.age,
      required this.idTrainer,
     });

  Usuario(
      {
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
     });


  @override
  String toString() {
    return userName;
  }

String getEmail(){
  return mail;
}

  String getAge(){
    return age;
  }

  void setUserName(String name){
    userName = name;
  }

  void setAge(String edad){
    age = edad;
  }
  
  void setEmail(String email){
    mail = email;
  }
}