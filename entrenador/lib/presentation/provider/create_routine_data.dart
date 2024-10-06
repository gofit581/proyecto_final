import 'package:entrenador/core/entities/Exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineData extends StateNotifier<List<Exercise>> {
  RoutineData() : super([]);

  void addExercise(Exercise exercise) {
    state = [...state, exercise];
  }

  void removeExercise(int index) {
    final updatedExercises = List<Exercise>.from(state);
    updatedExercises.removeAt(index);
    state = updatedExercises;
  }

  void updateExercise(int index, Exercise exercise) {
    final updatedExercises = List<Exercise>.from(state);
    updatedExercises[index] = exercise;
    state = updatedExercises;
  }
}

final routineDataProvider = StateNotifierProvider<RoutineData, List<Exercise>>((ref) {
  return RoutineData();
});