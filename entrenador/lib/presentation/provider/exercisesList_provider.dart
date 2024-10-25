import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/services/exercise_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exercisesListProvider = FutureProvider.family<List<Exercise>, String>((ref, trainerCode) async {
  final exerciseManager = ExerciseService();
  //return await exerciseManager.getExercises(); ESTO ES PARA TESTEAR
  return await exerciseManager.getExercisesByTrainerId(trainerCode);
});