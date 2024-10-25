import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/TrainingDay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Week {
  List<TrainingDay> days;

  Week({required this.days});
}

class RoutineNoti {
  List<Week> weeks;

  RoutineNoti({
    required this.weeks,
  });
}

class ExercisesNotifier extends Notifier<RoutineNoti> {
  @override
  RoutineNoti build() {
    return RoutineNoti(weeks: []);
  }

  void initializeRoutine(int weeksCount, int daysPerWeek) {
    state = RoutineNoti(
      weeks: List.generate(weeksCount, (weekIndex) => Week(
        days: List.generate(daysPerWeek, (dayIndex) => TrainingDay(
          observation: '',
          exercises: [Exercise.create(" ", 0, 0)],
        )),
      )),
    );
  }


  void addExercise(int weekIndex, int dayIndex, Exercise exercise) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return; 
    if (dayIndex < 0 || dayIndex >= state.weeks[weekIndex].days.length) return;


    List<TrainingDay> updatedDays = List.from(state.weeks[weekIndex].days);
    updatedDays[dayIndex] = TrainingDay(
      observation: updatedDays[dayIndex].observation,
      exercises: List.from(updatedDays[dayIndex].exercises)..add(exercise),
    );


    state = RoutineNoti(
      weeks: List.from(state.weeks)..[weekIndex] = Week(days: updatedDays),
    );
  }


  void removeExercise(int weekIndex, int dayIndex, int exerciseIndex) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return; 
    if (dayIndex < 0 || dayIndex >= state.weeks[weekIndex].days.length) return; 
    if (exerciseIndex < 0 || exerciseIndex >= state.weeks[weekIndex].days[dayIndex].exercises.length) return;


    List<TrainingDay> updatedDays = List.from(state.weeks[weekIndex].days);
    updatedDays[dayIndex] = TrainingDay(
      observation: updatedDays[dayIndex].observation,
      exercises: List.from(updatedDays[dayIndex].exercises)..removeAt(exerciseIndex),
    );

    state = RoutineNoti(
      weeks: List.from(state.weeks)..[weekIndex] = Week(days: updatedDays),
    );
  }


  void addObservation(int weekIndex, int dayIndex, String observation) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return; 
    if (dayIndex < 0 || dayIndex >= state.weeks[weekIndex].days.length) return;


    List<TrainingDay> updatedDays = List.from(state.weeks[weekIndex].days);
    updatedDays[dayIndex] = TrainingDay(
      observation: observation,
      exercises: updatedDays[dayIndex].exercises,
    );


    state = RoutineNoti(
      weeks: List.from(state.weeks)..[weekIndex] = Week(days: updatedDays),
    );
  }

  void useRoutine(List<List<TrainingDay>> routine) {
      // Verifica que la rutina no esté vacía
  if (routine.isEmpty) return;

  // Crea una lista de semanas a partir de la rutina proporcionada
  List<Week> weeks = routine.map((days) {
    return Week(days: List.from(days)); // Crea un objeto Week para cada lista de días
  }).toList();

  // Actualiza el estado del notifier
  state = RoutineNoti(weeks: weeks);
  }
}

final exercisesNotifierProvider = NotifierProvider<ExercisesNotifier, RoutineNoti>(
  () => ExercisesNotifier(),
);