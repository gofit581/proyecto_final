import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/RoutineManager.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/presentation/provider/counter_day_routine.dart';
import 'package:entrenador/presentation/provider/current_screen.dart';
import 'package:entrenador/presentation/provider/exercisesList_provider.dart';
import 'package:entrenador/presentation/provider/exercises_provider.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRoutine2Screen extends ConsumerWidget {
  final Routine routine;
  static const name = "CreateRoutine2";

  const CreateRoutine2Screen({super.key, required this.routine});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    RoutineManager routineManager = RoutineManager();
    TrainerManager trainerManager = TrainerManager();
    Trainer actualTrainer = trainerManager.getLoggedUser()!;
    final exercisesAsync = ref.watch(exercisesListProvider(actualTrainer.trainerCode));
    final TextEditingController _routineObservationDayController = TextEditingController();
    final day = ref.watch(counterDayProvider);
    final week = ref.watch(counterWeekProvider);
    final maxDays = routine.trainingDays;
    int indexDay = day - 1;
    int indexWeek = week -1;

    void generateRoutine(){
      for(int w = 0; w < routine.duration; w++){
        for(int d =0; d < maxDays; d++){
          routine.exercises[w][d].exercises = ref.watch(exercisesNotifierProvider).weeks[w].days[d].exercises;
          routine.exercises[w][d].observation = ref.watch(exercisesNotifierProvider).weeks[w].days[d].observation;
        } 
      }

    }

  if (ref.watch(exercisesNotifierProvider).weeks[indexWeek].days[indexDay].observation.isNotEmpty) {
  _routineObservationDayController.text = ref.watch(exercisesNotifierProvider).weeks[indexWeek].days[indexDay].observation;
  } else {
    _routineObservationDayController.text = '';
  }

  void resetProviders(){
    ref.read(counterDayProvider.notifier).state = 1;
    ref.read(counterWeekProvider.notifier).state = 1;
    ref.read(changesProvider.notifier).state = false;
  }


    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await _onExitDialog(context,ref);
        return shouldPop;
      },
      child: Scaffold(
          appBar: CustomAppBar(title: 'Rutina: ${routine.title}'),
          bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
          body: exercisesAsync.when(
            data: (exercisesOptions){        
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('$indexWeek'),
                    Text('$indexDay'),
                    Text('Semana $week de ${routine.duration}'),
                    Text('Día de rutina $day/$maxDays'),
                    Text(routine.title),
                    Text('Objetivo: ${routine.typeOfTraining?.name}'),
                    Text('Duración en semanas: ${routine.duration}'),
                    Text('Tiempo de descanso entre ejercicios: ${routine.rest} segundos'),
                    const SizedBox(height: 20),
                    _AddExerciseView(exercisesOptions: exercisesOptions, indexDay: indexDay, indexWeek: indexWeek, actualTrainerCode: actualTrainer.trainerCode),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller:  _routineObservationDayController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Observación del día',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),               
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (day > 1)
                          ElevatedButton(
                            onPressed: () {
                              ref.read(counterDayProvider.notifier).state--;
                              context.push('/createRoutine2', extra: routine);
                            },
                            child: const Icon(Icons.arrow_left),
                          ),
                        if (day < maxDays)
                        ElevatedButton(
                          onPressed: () {                       
                              ref.read(counterDayProvider.notifier).state++;
                              ref.read(exercisesNotifierProvider.notifier).addObservation(indexWeek, indexDay, _routineObservationDayController.text);
                              context.push('/createRoutine2', extra: routine);                      
                          },
                          child: const Icon(Icons.arrow_right),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                              context.push('/createExercise', extra: routine);
                          },
                          child: const Text('Nuevo ejercicio'),
                        ),
                      ],
                    ),
                    if(day == maxDays && week < routine.duration)
                    ElevatedButton(
                      onPressed: (){
                        ref.read(exercisesNotifierProvider.notifier).addObservation(indexWeek, indexDay, _routineObservationDayController.text);
                        context.push('/createRoutine2', extra: routine);
                        resetCounter(ref);
                        ref.read(counterWeekProvider.notifier).state++;
                      },
                      child: const Text('Proxima semana'),
                      ),
                    if(week > 1)
                    ElevatedButton(
                      onPressed: (){
                        ref.read(counterWeekProvider.notifier).state--;
                        refillCounter(ref);
                        context.push('/createRoutine2', extra: routine);
                      },
                      child: const Text('Semana anterior')
                      ),
                    if (day == maxDays && week == routine.duration) ...[
                      ElevatedButton(
                        onPressed: () {
                          ref.read(exercisesNotifierProvider.notifier).addObservation(indexWeek, indexDay, _routineObservationDayController.text);
                          generateRoutine();
                          Routine newRoutine = Routine(
                            title: routine.title,
                            description: routine.description,
                            duration: routine.duration,
                            aim: routine.aim,
                            image: routine.image,
                            typeOfTraining: routine.typeOfTraining,
                            idTrainer: actualTrainer.trainerCode,
                            trainingDays: routine.trainingDays,
                            rest: routine.rest,
                            exercises: routine.exercises,
                          );                    
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Nueva Rutina: ${routine.title}'),
                                content: const Text('¿Estás seguro que deseas crear esta nueva rutina?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      routineManager.addRoutine(newRoutine, actualTrainer);
                                      resetProviders();
                                      Navigator.of(context).pop(); 
                                      context.goNamed(CalendarioScreen.name); 
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); 
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.check),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Nueva Rutina: ${routine.title}'),
                                content: const Text('¿Estás seguro que deseas descartar esta nueva rutina?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      resetProviders();
                                      context.goNamed(CalendarioScreen.name); 
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); 
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ],
                ),
              ),
            );
            }, loading: () => const Center(child: CircularProgressIndicator()),
             error: (error, stack) => Center(child: Text('Error: $error')),
          ),
      ),
    );
  }
}

  Future<bool> _onExitDialog(BuildContext context,ref) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Descartar cambios'),
          content: const Text('¿Estás seguro de que deseas salir y descartar los cambios?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                  ref.read(counterDayProvider.notifier).state = 1;
                  ref.read(counterWeekProvider.notifier).state = 1;
                  ref.read(changesProvider.notifier).state = false;
                Navigator.of(context).pop(true);
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    ) ??
        false;
  }
class _AddExerciseView extends ConsumerStatefulWidget {
  final List<Exercise> exercisesOptions;
  final int indexDay;
  final int indexWeek;
  final String actualTrainerCode;

  const _AddExerciseView({
    required this.exercisesOptions,
    required this.indexDay,
    required this.indexWeek,
    required this.actualTrainerCode
  });

  @override
  ConsumerState<_AddExerciseView> createState() => _AddExerciseViewState();
}

class _AddExerciseViewState extends ConsumerState<_AddExerciseView> {
  List<Exercise> selectedExercises = [];


  @override
  void initState() {
    super.initState();
    // ignore: unused_result
    ref.refresh(exercisesListProvider(widget.actualTrainerCode));
  }


  @override
  Widget build(BuildContext context) {
    final exerciseSelected = ref.watch(exercisesNotifierProvider).weeks[widget.indexWeek].days[widget.indexDay].exercises;
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exerciseSelected.length,
          itemBuilder: (BuildContext context, int index) {
            return _ExerciseEntry(
              exercise: exerciseSelected[index],
              exercises: widget.exercisesOptions,
              onRemove: () { ref.read(exercisesNotifierProvider.notifier).removeExercise(widget.indexWeek,widget.indexDay,index);
              ref.read(changesProvider.notifier).state = true;},
            );
          },
        ),     
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: (){
             ref.read(exercisesNotifierProvider.notifier).addExercise(widget.indexWeek, widget.indexDay,Exercise.create("", 0, 0));
             ref.read(changesProvider.notifier).state = true;
             },
          child: const Text('+'),
        ),
      ],
    );
  }
}

class _ExerciseEntry extends ConsumerStatefulWidget {
  final Exercise exercise;
  final List<Exercise> exercises;
  final VoidCallback onRemove;

  const _ExerciseEntry({
    required this.exercise,
    required this.exercises,
    required this.onRemove,
  });

  @override
  ConsumerState<_ExerciseEntry> createState() => _ExerciseEntryState();
}

class _ExerciseEntryState extends ConsumerState<_ExerciseEntry> {
  late String? exerciseSelected;

  @override
  Widget build(BuildContext context) {
    final initialValue = widget.exercises.map((e) => e.title).contains(widget.exercise.title) ? widget.exercise.title : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IntrinsicWidth(
          child: DropdownButtonFormField<String>(
            value: initialValue,
            decoration: const InputDecoration(
              labelText: 'Ejercicio',
              border: OutlineInputBorder(),
            ),
            items: widget.exercises.map((exercise) {
              return DropdownMenuItem<String>(
                value: exercise.title,
                child: Text(exercise.title!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  exerciseSelected = value;
                  widget.exercise.setTitle(value);
                });
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: widget.onRemove,
        ),
        Column(
          children: [
            const Text('Series'),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 15),
                  onPressed: () {
                    setState(() {
                      widget.exercise.aumentarSerie();
                      ref.read(changesProvider.notifier).state = true;
                    });
                  },
                ),
                Text('${widget.exercise.series}'),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 15),
                  onPressed: () {
                    setState(() {
                      if (widget.exercise.series! > 0) {
                        widget.exercise.restarSerie();
                        ref.read(changesProvider.notifier).state = true;
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            const Text('Reps'),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 15),
                  onPressed: () {
                    setState(() {
                      widget.exercise.aumentarRepeticiones();
                      ref.read(changesProvider.notifier).state = true;
                    });
                  },
                ),
                Text('${widget.exercise.repetitions}'),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 15),
                  onPressed: () {
                    setState(() {
                      if (widget.exercise.repetitions! > 0) {
                        widget.exercise.restarRepeticiones();
                        ref.read(changesProvider.notifier).state = true;
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
