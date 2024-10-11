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
  String? id;
  //  int? id;
  int rest;
  late String idTrainer;
  late List<String> observationsPerDay;
  late int trainingDays;

  //esto es de user
  Routine.parcial({
    required this.title,
    required this.duration,
    required this.image,
    required this.rest,
    required this.trainingDays,
  }) {
    this.exercises = [
      [Exercise.vacio()],
      [Exercise.vacio()],
      [Exercise.vacio()],
    ];
    this.observationsPerDay = List<String>.filled(trainingDays, '');
  }

  Routine({
    required this.title,
    required this.description,
    required this.duration,
    required this.exercises,
    required this.aim,
    required this.typeOfTraining,
    required this.rest,
    required this.idTrainer,
    required this.observationsPerDay,
    required this.trainingDays,
    this.image,
    this.id,
  });

  int getDuration() {
    return duration;
  }

  String getTitle() {
    return title;
  }

/*   void resetExercises() {
      for (var exercise in exercises) {
        exercise.done = false;
      }
  } */

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      exercises: (json['exercises'] as List<dynamic>)
          .map((group) => (group as List<dynamic>)
              .map((exercise) => Exercise.fromJson(exercise))
              .toList())
          .toList(),
      aim: json['aim'],
      typeOfTraining: json['typeOfTraining'] != null
          ? TypeOfTraining.values.firstWhere(
              (e) => e.toString().split('.').last == json['typeOfTraining'],
              orElse: () => TypeOfTraining.LoseWeight)
          : null,
      rest: json['rest'],
      idTrainer: json['idTrainer'],
      observationsPerDay: List<String>.from(json['observationsPerDay']),
      trainingDays: json['trainingDays'],
      id: json['id'],
    );
  }
}
