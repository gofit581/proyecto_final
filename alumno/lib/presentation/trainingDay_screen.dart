// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:alumno/core/entities/Exercise.dart';
import 'package:alumno/core/entities/Routine.dart';
import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/services/update_service.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/widget/custom_botton_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class TrainingdayScreen extends StatefulWidget {
  static const String name = 'TrainingDayScreen';

  const TrainingdayScreen({super.key});

  @override
  State<TrainingdayScreen> createState() => _TrainingdayScreenState();
}

class _TrainingdayScreenState extends State<TrainingdayScreen> {

Usuario actualUser = UserManager().getLoggedUser()!;


  @override
  Widget build(BuildContext context) {

  Routine actualRoutine = actualUser.actualRoutine!;
  int totalSesions = actualUser.actualRoutine!.exercises.length * actualUser.actualRoutine!.exercises[0].length - 1;
  int days = actualRoutine.exercises[0].length;
  int indexWeek = ((actualUser.actualSesion) ~/ (days));
  int indexDay = ((actualUser.actualSesion) % (days));


    return Scaffold(
      appBar: CustomAppBar(title: actualRoutine.title!),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              _ExercisesView(actualRoutine: actualRoutine, indexWeek:indexWeek, indexDay:indexDay, actualUser: actualUser, totalSesions: totalSesions),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _ExercisesView extends StatefulWidget {
  final Routine actualRoutine;
  int indexWeek;
  int indexDay;
  int totalSesions;
  Usuario actualUser;

  _ExercisesView({required this.actualRoutine, required this.indexWeek, required this.indexDay, required this.actualUser, required this.totalSesions});

  @override
  State<_ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<_ExercisesView> {
  late List<List<bool>> checked;


  @override
  void initState() {
    super.initState();
    checked = List.generate(
      widget.actualRoutine.exercises.length,
      (index) => List.filled(widget.actualRoutine.exercises[index][widget.indexDay].exercises.length, false),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Exercise> exercises = widget.actualRoutine.exercises[widget.indexWeek][widget.indexDay].exercises; // Adjust based on your data structure
    int completedCount = checked[widget.indexWeek].where((isChecked) => isChecked).length;
    double progress = exercises.isNotEmpty ? completedCount / exercises.length : 0;
    bool allCompleted = completedCount == exercises.length;


    return Column(
      children: [
        Text(widget.actualRoutine.exercises[widget.indexWeek][widget.indexDay].observation),
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
                    value: checked[widget.indexWeek][index],
                    onChanged: (bool? value) {
                      setState(() {
                        checked[widget.indexWeek][index] = value!;
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
          onPressed: allCompleted ? () => _sesionCompleta(context, widget.actualUser, widget.totalSesions) : null,
          
          child: const Text('Finalizar Entrenamiento'),
        ),
      ],
    );
  }
}

void _sesionCompleta(BuildContext context, Usuario actualUser, int totalSesions) {
  UpdateService update = UpdateService();
  UserManager userManager = UserManager();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: actualUser.actualSesion < totalSesions ? const Text('Entrenamiento del dia terminado') : const Text('Rutina terminada'),
        content: actualUser.actualSesion < totalSesions ? const Text('¡Has completado todos los ejercicios!') : 
        const Text('¡Has completado todas las sesiones de tu rutina!'),
        actions: [
          TextButton(
            onPressed: () async {
                         
              if(actualUser.actualSesion < totalSesions){
                actualUser.completeSesion();
              } else{
                actualUser.resetSesions();
                actualUser.deleteRoutine();
              }
              // Falta pegada a la BD para actualizar el Usuario
              await update.updateUser(actualUser);
              bool loginSuccess = await userManager.login(
                    actualUser.mail,
                    actualUser.password);
              Usuario? usuario = userManager.getLoggedUser();

              if (loginSuccess && usuario != null) {
                userManager.setLoggedUser(usuario);
              }                
              // ignore: use_build_context_synchronously
              context.goNamed(CalendarioScreen.name);
            },
            
            child: const Text('Aceptar'),
        ),
    
        ],
      );
    },
  );
}
