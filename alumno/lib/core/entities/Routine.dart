import 'package:alumno/core/entities/TrainingDay.dart';
import 'package:alumno/core/entities/TypeOfTraining.dart';

class Routine {
  String? title;
  String? description;
  int? duration;
  List<List<TrainingDay>> exercises;
  int? aim;
  String? image;
  TypeOfTraining? typeOfTraining;
  String? id;
  int? rest;
  String? idTrainer;
  int? trainingDays;
  Routine? actualRoutine;


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
    return duration!;
  }

  String? getTitle() {
    return title;
  }

  String? getNameTypeOfTraining(){
    return typeOfTraining?.name;
  }

    factory Routine.fromJson(Map<String, dynamic> json) {
      print(json);
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

  Map<String, dynamic> toJson() {
  return {
    'title': title,
    'description': description,
    'duration': duration,
    'aim': aim,
    'typeOfTraining': typeOfTraining?.toJson(),
    'rest': rest,
    'idTrainer': idTrainer,
    'trainingDays': trainingDays,
    'id': id,
    'exercises': exercises.map((week) =>
      week.map((trainingDay) => trainingDay.toJson()).toList()
    ).toList(),
  };
}
}