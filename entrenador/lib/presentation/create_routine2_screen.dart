import 'package:entrenador/core/app_router.dart';
import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/presentation/provider/counter_day_routine.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class CreateRoutine2Screen extends ConsumerWidget {
  static const String name = 'CreateRoutine2Screen';
  final Map<Routine, Usuario> datos;

  const CreateRoutine2Screen({super.key, required this.datos});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Usuario user = datos.values.first;
    Routine routine = datos.keys.first;
    List<Exercise> exercises = [
      Exercise(title: 'Flexiones', imageLink: 'hola', description: 'hola'),
      Exercise(title: 'Sentadillas', imageLink: 'hola', description: 'hola')
    ]; // estos vienen de la lista de Ejercicios del Trainer

    final day = ref.watch(counterDayProvider);
    final maxDays = int.parse(user.age);
    int indexDay = day - 1;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rutina: ${routine.title}',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Dia de rutina $day/$maxDays'),
              Text(routine.title),
              Text('Objetivo ${routine.image}'),
              Text('Duracion en semanas: ${routine.duration}'),
              Text('Tiempo de descanso entre ejercicios: ${routine.rest}'),
              const SizedBox(height: 20,),
              _AddExerciseView(exercises: exercises,), /* routine.exercises[indexDay]), */
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                if(day > 1)

                ElevatedButton(
                onPressed: () {                   
                    context.push('/createRoutine2', extra: datos); // no me aparecen los datos guardados, deberia estar en un estado y que permanezcan ahi
                    ref.read(counterDayProvider.notifier).state--;
                    indexDay--;            
                },
                child: const Icon(Icons.arrow_left),
              ),
              ElevatedButton(
                onPressed: () {                   
                  if(day < maxDays){
                    context.push('/createRoutine2', extra: datos);
                    ref.read(counterDayProvider.notifier).state++;
                    indexDay++;
                  }                  
                },
                child: const Icon(Icons.arrow_right),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {                   
                  if(day < maxDays){
                    //context.push('/createExercise');
                  }                  
                },
                child: const Text('Nuevo ejercicio'),
              ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (day == maxDays)...[
                ElevatedButton(
                onPressed: () {
                  // Pegue a la base de datos y guarde la rutina
                  // Pop up que te pregunte si estas seguro que no queres cambiar nada
                },
                child: const Icon(Icons.check),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Pegue a la base de datos y guarde la rutina
                    // Pop up que te pregunte si estas seguro que no queres cambiar nada
                  },
                  child: const Icon(Icons.close),
                ),
                ],
                ]
              ),
            ]
          ),
        ),
      ),
    );
  }
}


class _AddExerciseView extends StatefulWidget {
  final List<Exercise> exercises;

  const _AddExerciseView({
    super.key,
    required this.exercises,
  });

  @override
  State<_AddExerciseView> createState() => _AddExerciseViewState();
}


class _AddExerciseViewState extends State<_AddExerciseView> {
  List<Exercise> selectedExercises = [];

    @override
  void initState() {
    super.initState();
    selectedExercises.add(Exercise.create(" ", 0, 0));
  }
 

  void _addExercise() {
    setState(() {
      selectedExercises.add(Exercise.create(" ", 0, 0));

    });
  }

  void _removeExercise(int index) {
    setState(() {
      selectedExercises.removeAt(index);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(      
      children: [
        // Lista de ejercicios seleccionados
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: selectedExercises.length,
          itemBuilder: (BuildContext context, int index) {
            return _ExerciseEntry(
              exercise: selectedExercises[index],
              exercises: widget.exercises,
              onRemove: () => _removeExercise(index),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _addExercise,
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
    Key? key,
    required this.exercise,
    required this.exercises,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<_ExerciseEntry> createState() => _ExerciseEntryState();
}
late String? exerciseSelected;
late Exercise newExercise = Exercise.create("", 0, 0);

class _ExerciseEntryState extends State<_ExerciseEntry> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 200,
          child: Expanded(
            child: DropdownButtonFormField<String>(
              value: widget.exercises[0].title,
              decoration: const InputDecoration(
                labelText: 'Ejercicio',
                border: OutlineInputBorder(),
              ),
              items: widget.exercises.map((exercise) {
                return DropdownMenuItem<String>(
                  value: exercise.title,
                  child: Text(exercise.title),
                );
              }).toList(),
              onChanged: (value) {
                exerciseSelected = value!;
                setState(() {
                  widget.exercise.setTitle(exerciseSelected!);
                });
              },
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove_circle),
          onPressed: widget.onRemove,
        ),
        Column(
          children: [
            const Text('Series'),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward, size: 15,),
                  onPressed: () {
                    setState(() {
                      widget.exercise.aumentarSerie();
                    });
                    
                  },
                ),
                Text('${widget.exercise.series}'),
                IconButton(
                  icon: Icon(Icons.arrow_downward, size: 15,),
                  onPressed: () {
                    setState(() {
                      if (widget.exercise.series > 0) {
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
                  icon: Icon(Icons.arrow_upward, size: 15,),
                  onPressed: () {
                    setState(() {
                      widget.exercise.aumentarRepeticiones();    
                    });
                    
                  },
                ),
                Text('${widget.exercise.repetitions}'),
                IconButton(
                  icon: Icon(Icons.arrow_downward, size: 15,),
                  onPressed: () {
                    setState(() {
                      if (widget.exercise.repetitions > 0) {
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