import 'package:alumno/core/entities/Exercise.dart';
import 'package:alumno/core/entities/TrainingDay.dart';
import 'package:alumno/core/entities/TypeOfTraining.dart';

class Routine {
  final String title;
  late String description;
  late int duration;
  final List<List<TrainingDay>> exercises;
  late int aim;
  late String? image;
  late TypeOfTraining? typeOfTraining;
  late int? id;
  late int rest;
  late String idTrainer;
  late int trainingDays;

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
    required this.rest,
    required this.idTrainer,
    required this.trainingDays,
  });

  int getDuration() {
    return this.duration;
  }

  String getTitle() {
    return title;
  }

    factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      aim: json['aim'],
      typeOfTraining: json['typeOfTraining'] != null
          ? TypeOfTraining.values.firstWhere(
              (e) => e.toString().split('.').last == json['typeOfTraining'],
              orElse: () => TypeOfTraining.LoseWeight)
          : null,
      rest: json['rest'],
      idTrainer: json['idTrainer'],
      trainingDays: json['trainingDays'],
      id: json['id'],
      exercises:(json['exercises'] as List)
          .map((week) => (week as List)
              .map((day) => TrainingDay.fromJson(day))
              .toList())
          .toList(),
    );
  }

  toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'duration': duration,
      'exercises': exercises.map((e) => e.map((exercise) => exercise.toJson()).toList()).toList(),
      'typeOfTraining': typeOfTraining?.toJson(),
      'rest': rest,
      'idTrainer': idTrainer,
      'trainingDays': trainingDays,
      'id': id,
    };

    if (description != null) data['description'] = description;
    if (aim != null) data['aim'] = aim;
    if (image != null) data['image'] = image;
    
    return data;
  }

/*   void resetExercises() {
      for (var exercise in exercises) {
        exercise.done = false;
      }
  } */


}