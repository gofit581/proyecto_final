import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';

class Usuario {
  final String? id;
  String userName;
  String password;
  String mail;
  String age;
  TypeOfTraining? training;
  Routine? currentRoutine;
  final List<DateTime> timesDone;
  String? idTrainer;
  String? objectiveDescription;
  String? experience;
  String? discipline;
  String trainingDays = '0';
  String? trainingDuration;
  String? injuries;
  String? extraActivities;
  Trainer? profesor;
  int actualSesion;

  Usuario({
    required this.mail,
    required this.userName,
    required this.password,
    required this.age,
    this.idTrainer,
    this.training,
    this.currentRoutine,
    this.id,
    this.objectiveDescription,
    this.experience,
    this.discipline,
    required this.trainingDays,
    this.trainingDuration,
    this.injuries,
    this.extraActivities,
    List<DateTime>? timesDone,
    required this.actualSesion,
  }) : this.timesDone = timesDone ?? [];

  Usuario.parcial(
      {this.id,
      required this.userName,
      required this.password,
      required this.mail,
      required this.age,
      required this.idTrainer,
      required this.trainingDays,
      required this.timesDone,
      required this.actualSesion});

  // Usuario({
  //   this.id,
  //   required this.userName,
  //   required this.password,
  //   required this.mail,
  //   required this.age,
  //   required this.idTrainer,
  //   required this.objectiveDescription,
  //   required this.experience,
  //   required this.discipline,
  //   required this.trainingDays,
  //   required this.trainingDuration,
  //   required this.injuries,
  //   required this.extraActivities,
  // });

  @override
  String toString() {
    return userName;
  }

  void clearTimesDone() {
    this.timesDone.clear();
  }

    String getEmail() {
      return mail;
    }

    String getAge() {
      return age;
    }

    void setRoutine(Routine rutina) {
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

    void setUserName(String name) {
      this.userName = name;
    }

    Trainer? getProfesor() {
      return profesor;
    }

    void setProfesor(Trainer profesor) {
      profesor = profesor;
    }

    void setAge(String edad) {
      age = edad;
    }

    void setTraining(TypeOfTraining training) {
      this.training = training;
    }

    void setEmail(String email) {
      mail = email;
    }

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
      currentRoutine: json['currentRoutine'] != null
          ? Routine.fromJson(json['currentRoutine'])
          : null,
      actualSesion: json['actualSesion'],
    );
  }

    toJson() {}

  // static fromJson(claseData) {}
  }

  toJson() {}

