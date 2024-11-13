// ignore_for_file: file_names

import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/services/exercise_service.dart';
import 'package:entrenador/services/update_service.dart';

class ExerciseManager {
  static ExerciseService exerciseService = ExerciseService();
  static UpdateService updateService = UpdateService();
  // ignore: prefer_final_fields
  static List<Exercise> _exercises = [];

  void agregarRoutine(Exercise exercise) {
    _exercises.add(exercise);
  }

  Future<void> addExercise(Exercise exercise) async {
    await exerciseService.createExercise(exercise);
  }

  var validateExercise = (String title, String trainerId) async {
    bool result = await exerciseService.validateExercise(title, trainerId);
    return result;
  };
}