import 'package:alumno/core/entities/Exercise.dart';
import 'package:alumno/core/entities/TypeOfTraining.dart';

class Routine {
  final String title;
  late String description;
  late int duration;
  final List<Exercise> exercises;
  late int aim;
  late String? image;
  late TypeOfTraining typeOfTraining;
  late int? id;

  //esto es de user
  Routine.parcial({
    required this.title,
    required this.exercises,
  });

  Routine({
    required this.title,
    required this.description,
    required this.duration,
    required this.exercises,
    required this.aim,
    required this.typeOfTraining,
    this.image,
    this.id,
  });

  int getDuration() {
    return this.duration;
  }

  String getTitle() {
    return title;
  }


  void resetExercises() {
      for (var exercise in exercises) {
        exercise.done = false;
      }
  }


}