import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';

class Usuario {
  final String? id;
  String userName;
  String password;
  String mail;
  int age;
  TypeOfTraining? training;
  Routine? currentRoutine;
  final List<DateTime> timesDone; 
  
  Usuario(
      {required this.mail,
      required this.userName,
      required this.password,
      required this.age,
      required this.training,
      required this.currentRoutine,
      this.id,
      List<DateTime>? timesDone,
     }) : this.timesDone = timesDone ?? [];


  @override
  String toString() {
    return '$userName';
  }

  void clearTimesDone(){
    this.timesDone.clear();
  }

  Routine? getRoutine() {
    return currentRoutine;
  }

String getEmail(){
  return this.mail;
}
  void setRoutine(Routine rutina){
    currentRoutine = rutina;
     timesDone.clear();
  }

  
  void addDayDone(DateTime day) {
    timesDone.add(day);
    timesDone.sort((a, b) => a.compareTo(b));
  }


  void removeDayDone(DateTime day) {
    timesDone.remove(day);
  }

  int getAge(){
    return this.age;
  }

  void setUserName(String name){
    this.userName = name;
  }

  void setAge(int edad){
    age = edad;
  }

  void setTraining(TypeOfTraining training){
    this.training = training;
  }

  void setEmail(String email){
    mail = email;
  }
}
