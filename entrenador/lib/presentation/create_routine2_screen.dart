import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/RoutineManager.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/presentation/provider/counter_day_routine.dart';
import 'package:entrenador/presentation/provider/exercises_provider.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRoutine2Screen extends ConsumerWidget {
  final Map<Routine, Usuario> datos;
  static const name = "CreateRoutine2";

  const CreateRoutine2Screen({super.key, required this.datos});
  
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Definición de variables y controladores
    Usuario user = datos.values.first;
    Routine routine = datos.keys.first;
    RoutineManager routineManager = RoutineManager();
    TrainerManager trainerManager = TrainerManager();
    Trainer actualTrainer = trainerManager.getLoggedUser()!;

    
    // Ejercicios para test, la Screen deberia instanciar los ejercicios del Trainer Actual
    List<Exercise> exercisesOptions = [
      Exercise(title: 'Flexiones', imageLink: 'hola', description: 'hola'),
      Exercise(title: 'Sentadillas', imageLink: 'hola', description: 'hola'),
    ];
    final TextEditingController _routineObservationDayController = TextEditingController();
    final day = ref.watch(counterDayProvider);
    final maxDays = int.parse(user.age); //Estoy usando el Age porque es un valor INT, aca deberia ser: user.trainingDays
    int indexDay = day - 1;

    void generateRoutine(){
      for(int i =0; i < maxDays; i++){
        routine.exercises[i] = ref.watch(exercisesNotifierProvider).exercises[i];
        routine.observationsPerDay[i] = ref.watch(exercisesNotifierProvider).observations[i];
      } 
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Rutina: ${routine.title}'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Día de rutina $day/$maxDays'),
              Text(routine.title),
              Text('Objetivo: ${routine.typeOfTraining?.name}'),
              Text('Duración en semanas: ${routine.duration}'),
              Text('Tiempo de descanso entre ejercicios: ${routine.rest}'),
              const SizedBox(height: 20),
              _AddExerciseView(exercisesOptions: exercisesOptions, indexDay: indexDay),
              const SizedBox(height: 20),
              TextFormField(
                controller: _routineObservationDayController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Observación del día',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),               
              const SizedBox(height: 20),
              Text('${ref.watch(exercisesNotifierProvider).observations}'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (day > 1)
                    ElevatedButton(
                      onPressed: () {
                        ref.read(counterDayProvider.notifier).state--;
                        context.push('/createRoutine2', extra: datos);
                      },
                      child: const Icon(Icons.arrow_left),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (day < maxDays) {
                        ref.read(counterDayProvider.notifier).state++;
                        ref.read(exercisesNotifierProvider.notifier).addObservation(_routineObservationDayController.text);
                        context.push('/createRoutine2', extra: datos);
                      }
                    },
                    child: const Icon(Icons.arrow_right),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                        context.push('/createExercise', extra: datos);
                    },
                    child: const Text('Nuevo ejercicio'),
                  ),
                ],
              ),
              if (day == maxDays) ...[
                ElevatedButton(
                  onPressed: () {
                    ref.read(exercisesNotifierProvider.notifier).addObservation(_routineObservationDayController.text);
                    generateRoutine();
                    Routine newRoutine = Routine(
                      title: routine.title,
                      description: routine.description,
                      duration: routine.duration,
                      exercises: routine.exercises,
                      aim: routine.aim,
                      image: routine.image,
                      typeOfTraining: routine.typeOfTraining,
                      idTrainer: actualTrainer.trainerCode,
                      observationsPerDay: routine.observationsPerDay,
                      trainingDays: routine.trainingDays,
                      rest: routine.rest,
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
                                ref.read(counterDayProvider.notifier).state = 1;
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
      ),
    );
  }
}

class _AddExerciseView extends ConsumerStatefulWidget {
  final List<Exercise> exercisesOptions;
  final int indexDay;

  const _AddExerciseView({
    required this.exercisesOptions,
    required this.indexDay,
  });

  @override
  ConsumerState<_AddExerciseView> createState() => _AddExerciseViewState();
}

class _AddExerciseViewState extends ConsumerState<_AddExerciseView> {
  List<Exercise> selectedExercises = [];


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final exerciseSelected = ref.watch(exercisesNotifierProvider).exercises;
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exerciseSelected[widget.indexDay].length,
          itemBuilder: (BuildContext context, int index) {
            return _ExerciseEntry(
              exercise: exerciseSelected[widget.indexDay][index],
              exercises: widget.exercisesOptions,
              onRemove: () { ref.read(exercisesNotifierProvider.notifier).removeExercise(widget.indexDay,index);}, // no funciona
            );
          },
        ),     
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: (){ ref.read(exercisesNotifierProvider.notifier).addExercise(widget.indexDay,Exercise.create("", 0, 0));},
          child: const Text('+'),
        ),
      ],
    );
  }
}

class _ExerciseEntry extends StatefulWidget {
  final Exercise exercise;
  final List<Exercise> exercises;
  final VoidCallback onRemove;

  const _ExerciseEntry({
    required this.exercise,
    required this.exercises,
    required this.onRemove,
  });

  @override
  State<_ExerciseEntry> createState() => _ExerciseEntryState();
}

class _ExerciseEntryState extends State<_ExerciseEntry> {
  late String? exerciseSelected;

  @override
  Widget build(BuildContext context) {
    final initialValue = widget.exercises.map((e) => e.title).contains(widget.exercise.title) ? widget.exercise.title : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 200,
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
