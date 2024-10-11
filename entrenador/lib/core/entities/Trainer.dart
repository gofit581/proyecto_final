import 'dart:ffi';

import 'package:entrenador/core/entities/Clase.dart';
import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/Routine.dart';

class Trainer {
  final String? id;
  String userName;
  String age;
  String mail;
  String password;
  String trainerCode;
  int duracionClasesMinutos = 0;
  int trabajaDesdeHora = 0;
  int trabajaHastaHora = 0;
  List<Int> diasLaborales = [];
  List<Clase>? agenda = [];
  List<Routine>? rutinas = [];
  List<Exercise?> ejercicios = [];
  //List<User> clients;

Trainer(
     {
     this.id,
      required this.userName,
      required this.password,
      required this.mail,
      required this.age,
      required this.trainerCode,
      
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
