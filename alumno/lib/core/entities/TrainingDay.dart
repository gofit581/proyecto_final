import 'package:alumno/core/entities/Exercise.dart';

class TrainingDay{
  String observation;
 // List<TypeOfExercise> typeOfExercise;
  List<Exercise> exercises;

  TrainingDay({
    required this.observation,
    //required this.typeOfExercise,
    required this.exercises,
  });

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      observation: json['observation'],
      exercises: (json['exercises'] as List<dynamic>)
          .map((exerciseJson) => Exercise.fromJson(exerciseJson))
          .toList(),
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'observation': observation,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };
  }
}