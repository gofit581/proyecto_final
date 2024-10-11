import 'package:entrenador/core/entities/Exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineNoti {
  List<List<Exercise>> exercises; // Matriz de ejercicios por día
  List<String> observations;

  RoutineNoti({
    required this.exercises,
    required this.observations,
  });
}

class ExercisesNotifier extends Notifier<RoutineNoti> {
  @override
  RoutineNoti build() {
    return RoutineNoti(exercises: [], observations: [""]); // Estado inicial
  }

  // Inicializa la rutina con una cantidad de días
  void initializeRoutine(int days) {
    state = RoutineNoti(
      exercises: List.generate(days, (index) => [Exercise.create(" ", 0, 0)]), // Inicializa con días vacíos
      observations: [""],
    );
  }

  // Agrega un ejercicio a un día específico
  void addExercise(int dayIndex, Exercise exercise) {
    if (dayIndex < 0 || dayIndex >= state.exercises.length) return; // Validar índice del día

    state = RoutineNoti(
      exercises: List.from(state.exercises)
        ..[dayIndex].add(exercise), // Agregar ejercicio al día específico
      observations: state.observations,
    );
  }

  // Elimina un ejercicio de un día específico
  void removeExercise(int dayIndex, int exerciseIndex) {
  if (dayIndex < 0 || dayIndex >= state.exercises.length) return; // Validar índice del día
  if (exerciseIndex < 0 || exerciseIndex >= state.exercises[dayIndex].length) return; // Validar índice del ejercicio

  // Crear una copia del estado actual y eliminar el ejercicio
  List<List<Exercise>> updatedExercises = List.from(state.exercises);
  updatedExercises[dayIndex] = List.from(updatedExercises[dayIndex])..removeAt(exerciseIndex);

  // Actualizar el estado
  state = RoutineNoti(
    exercises: updatedExercises,
    observations: state.observations,
  );
  }

  // Agrega una observación
  void addObservation(String observation) {
    state = RoutineNoti(
      exercises: state.exercises,
      observations: [...state.observations, observation],
    );
  }

}


final exercisesNotifierProvider = NotifierProvider<ExercisesNotifier, RoutineNoti>(
  () => ExercisesNotifier(),
);
