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
  List<Clase>? agenda;
  List<int>? diasLaborales;
  int? duracionClasesMinutos;
  int? trabajaDesdeDia;
  int? trabajaHastaDia;
  int? trabajaDesdeHora;
  int? trabajaHastaHora;
  double? precioPorClase;
  late List<Routine> routines;
  late List<Exercise> exercises =[];
  //List<User> clients;

Trainer.parcial({
     this.id,
      required this.userName,
      required this.password,
      required this.mail,
      required this.age,
      required this.trainerCode,
      
});

Trainer({
    this.id,
    required this.userName,
    required this.password,
    required this.mail,
    required this.age,
    required this.trainerCode,
    required this.agenda,
    required this.diasLaborales,
    required this.duracionClasesMinutos,
    required this.trabajaDesdeHora,
    required this.trabajaHastaHora,
    required this.precioPorClase,
    required this.routines,
}): exercises =[];

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

String getTrainerCode(){
  return trainerCode;
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

void addRoutine(Routine routine){
  this.routines.add(routine);
}

void setAgenda(List<Clase> newAgenda) {
  agenda = newAgenda;
}

}
