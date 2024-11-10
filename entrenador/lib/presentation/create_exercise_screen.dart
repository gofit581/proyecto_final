import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/ExerciseManager.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/presentation/provider/exercisesList_provider.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateExerciseScreen extends ConsumerStatefulWidget {

  static const name = 'CreateExerciseScreen';
  final Routine routine;

  const CreateExerciseScreen({super.key, required this.routine});

  @override
  ConsumerState<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends ConsumerState<CreateExerciseScreen> {

  final TextEditingController _exerciseTitleController = TextEditingController();
  final TextEditingController _exerciseImageLinkController = TextEditingController();
  final TextEditingController _exerciseDescriptionController = TextEditingController();
  ExerciseManager exerciseManager = ExerciseManager();


  @override
  Widget build(BuildContext context) {
  TrainerManager trainerManager = TrainerManager();
  Trainer actualTrainer = trainerManager.getLoggedUser()!;
    
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Crear Ejercicio',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _exerciseTitleController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del ejercicio',
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          )
                        ),
                      ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _exerciseImageLinkController,
                        decoration: InputDecoration(
                          labelText: 'Ingrese el video del ejercicio',
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          )
                        ),
                      ),
                ),
                const SizedBox(height: 40),   
                SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _exerciseDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Ingrese una descripcion del ejercicio',
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          )
                        ),
                      ),
                ),
                const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async{
                  if (_exerciseTitleController.text.isEmpty || _exerciseImageLinkController.text.isEmpty || _exerciseDescriptionController.text.isEmpty) {
                    
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Todos los campos son obligatorios.')),
                      );
                      
                    } else if(await exerciseManager.validateExercise(_exerciseTitleController.text, actualTrainer.trainerCode)){
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nombre de ejercicio ya utilizado, intentelo de nuevo')),
                      );
                      return;
                    }
                  
                  Exercise newExercise = Exercise(
                    title: _exerciseTitleController.text,
                    imageLink: _exerciseImageLinkController.text,
                    description: _exerciseDescriptionController.text,
                    idTrainer: actualTrainer.getTrainerCode()
                    );
                   showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Nueva Ejercicio: ${newExercise.title}'),
                          content: const Text('¿Estás seguro que deseas crear este nueva ejercicio?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                exerciseManager.addExercise(newExercise);
                                // ignore: unused_result
                                ref.refresh(exercisesListProvider(actualTrainer.trainerCode));                                
                                Navigator.of(context).pop();
                                context.pop(widget.routine);                                
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
                  child: const Text('Agregar ejercicio'),             
                ),                                          
              ],
            ),
          ),
          ),
        ),    
    );
  }
}