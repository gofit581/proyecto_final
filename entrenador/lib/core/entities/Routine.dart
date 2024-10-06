import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';

class Routine {
   String title;
   String? description;
   int duration;
  late List<List<Exercise>> exercises;
   int? aim;
   String? image;
   TypeOfTraining? typeOfTraining;
   int? id;
   String? rest;
  late List<String> observacionesPorDia;
  late int trainingDays;

  //esto es de user
  Routine.parcial({
    required this.title,
    required this.duration,
    required this.image,
    required this.rest,
    required this.trainingDays,
  }) {
    this.exercises = [[Exercise.vacio()],[Exercise.vacio()],[Exercise.vacio()],];
    this.observacionesPorDia = List<String>.filled(trainingDays,'');
  }

  Routine({
    required this.title,
    required this.description,
    required this.duration,
    required this.exercises,
    required this.aim,
    required this.typeOfTraining,
    required this.rest,
    this.image,
    this.id,
  });

  int getDuration() {
    return this.duration;
  }

  String getTitle() {
    return title;
  }

/*   void resetExercises() {
      for (var exercise in exercises) {
        exercise.done = false;
      }
  } */


}