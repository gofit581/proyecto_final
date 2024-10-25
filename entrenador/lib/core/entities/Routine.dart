import 'package:entrenador/core/entities/TrainingDay.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';

class Routine {
  String title;
  String? description;
  int duration;
  int? aim;
  String? image;
  TypeOfTraining? typeOfTraining;
  String? id;
  int rest;
  late String idTrainer;
  late int trainingDays;
  late List<List<TrainingDay>> exercises;

  //esto es de user
  Routine.parcial({
    required this.title,
    required this.duration,
    required this.typeOfTraining,
    required this.rest,
    required this.trainingDays,
  }) {
    exercises = List.generate(
      duration,
      (weekIndex) => List.generate(
        trainingDays,
        (dayIndex) => TrainingDay(observation: '', exercises: []),
      ),
    );
  }


  Routine({
    required this.title,
    required this.description,
    required this.duration,
    required this.aim,
    required this.typeOfTraining,
    required this.rest,
    required this.idTrainer,
    required this.trainingDays,
    required this.exercises,
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
}