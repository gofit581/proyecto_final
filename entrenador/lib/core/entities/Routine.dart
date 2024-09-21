import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';

class Routine {
  final String title;
  final String description;
  final int duration;
  final List<Exercise> exercises;
  final int aim;
  final String? image;
  final TypeOfTraining typeOfTraining;
  final int? id;

  //esto es de user

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