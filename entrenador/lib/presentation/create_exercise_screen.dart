import 'package:entrenador/core/entities/Exercise.dart';
import 'package:entrenador/core/entities/ExerciseManager.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateExerciseScreen extends StatefulWidget {

  static const name = 'CreateExerciseScreen';
  final Map<Routine,Usuario> datos;

  const CreateExerciseScreen({super.key, required this.datos,});

  @override
  State<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {

  TextEditingController _exerciseTitleController = TextEditingController();
  TextEditingController _exerciseImageLinkController = TextEditingController();
  TextEditingController _exerciseDescriptionController = TextEditingController();
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
                onPressed: (){
                  if (_exerciseTitleController.text.isEmpty || _exerciseImageLinkController.text.isEmpty || _exerciseDescriptionController.text.isEmpty) {
                    
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Todos los campos son obligatorios.')),
                      );
                      return;
                    } else{
                  Exercise newExercise = Exercise(
                    title: _exerciseTitleController.text,
                    imageLink: _exerciseImageLinkController.text,
                    description: _exerciseDescriptionController.text,
                    idTrainer: actualTrainer.getTrainerCode()
                    );
                   showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Nueva Ejercicio: ${newExercise.title}'),
                          content: const Text('¿Estás seguro que deseas crear este nueva ejercicio?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                exerciseManager.addExercise(newExercise);
                                Navigator.of(context).pop();
                                if(widget.datos.isNotEmpty){
                                  context.pop(widget.datos);

                                }else{
                                  context.push('/calendar');
                                }
                                
                                
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
                    }
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