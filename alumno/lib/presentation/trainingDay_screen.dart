import 'package:alumno/core/app_router.dart';
import 'package:alumno/core/entities/Exercise.dart';
import 'package:alumno/core/entities/Routine.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainingdayScreen extends StatelessWidget {
  static const String name = 'TrainingDayScreen';
  TrainingdayScreen({super.key});

  final UserManager userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = [
      Exercise.prueba(title: "Flexiones", series: 4, repetitions: 12),
      Exercise.prueba(title: "Sentadillas", series: 4, repetitions: 10)
    ];

    //HAY QUE TRAER LA RUTINA DESDE LA BASE DE DATOS
    Routine actualRoutine = Routine.parcial(title: "Fuerza", exercises: exercises);

    return Scaffold(
      appBar: CustomAppBar(title: actualRoutine.title),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              _ExercisesView(actualRoutine: actualRoutine),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisesView extends StatefulWidget {
  final Routine actualRoutine;

  const _ExercisesView({
    required this.actualRoutine,
  });

  @override
  State<_ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<_ExercisesView> {
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List<bool>.filled(widget.actualRoutine.exercises.length, false);
  }

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = widget.actualRoutine.exercises;
    int completedCount = checked.where((isChecked) => isChecked).length;
    double progress = completedCount / exercises.length;

    // Verificar si todos los ejercicios están completados
    bool allCompleted = completedCount == exercises.length;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercises.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(exercises[index].title),
                  Text(' ${exercises[index].series} X ${exercises[index].repetitions}'),
                  Checkbox(
                    value: checked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        checked[index] = value!;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 20),
        Text('${(progress * 100).toStringAsFixed(0)}% completado'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: allCompleted ? () {
              _showCompletionDialog(context);
              
          } : null,
          child: const Text('Finalizar Entrenamiento'),
        ),
      ],
    );
  }
}
void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Entrenamiento Completo'),
          content: const Text('¡Has completado todos los ejercicios!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.goNamed(CalendarioScreen.name); // Cerrar el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }