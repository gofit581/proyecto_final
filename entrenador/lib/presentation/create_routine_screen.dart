import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/presentation/create_routine2_screen.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRoutineScreen extends StatefulWidget {

  static const String name = 'CreateRoutineScreen';
  /*final Usuario actualUser;*/

  CreateRoutineScreen({super.key/*, required this.actualUser*/});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {

  final TextEditingController _routineTypeOfTrainingController = TextEditingController();
  final TextEditingController _routineTitleController = TextEditingController();
  final TextEditingController _routineDurationController = TextEditingController();
  final TextEditingController _routineRestController = TextEditingController();
  List<TypeOfTraining> typeOfTraining = TypeOfTraining.values;
  TypeOfTraining selectedTraining = TypeOfTraining.LoseWeight;
  late TypeOfTraining aim;
  Usuario actualUser = Usuario.parcial(userName: 'Pepe', password: '1', mail: '1', age: '3', idTrainer: '1', trainingDays: '3');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Crear rutina',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [          
              TextFormField(
                controller: _routineTitleController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nombre de la nueva rutina',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<TypeOfTraining>(
                value: selectedTraining,
                decoration: InputDecoration(
                  labelText: 'Tipo de Rutina',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: typeOfTraining.map((dato) {
                  return DropdownMenuItem<TypeOfTraining>(
                    value: dato,
                    child: Text(dato.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTraining = value!;
                    _routineTypeOfTrainingController.text = value.name;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _routineDurationController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Duracion de la rutina(semanas)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _routineRestController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Tiempo de descanso entre ejercicios',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_routineTitleController.text.isEmpty || _routineDurationController.text.isEmpty || _routineRestController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, ingrese todos los campos'),
                      ),
                    );
                  } else{

                    Routine routine = Routine.parcial(
                      title: _routineTitleController.text,
                      duration: int.parse(_routineDurationController.text),
                      image: _routineTypeOfTrainingController.text,
                      rest: _routineDurationController.text,
                      trainingDays : int.parse(actualUser.trainingDays),
                    );

                    
                    try {
                        Map<Routine, Usuario> datos = {
                          routine: actualUser,
                        };
                        context.push('/createRoutine2',                          
                          extra: datos);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al crear rutina'),
                          ),
                        );
                      }

                  }
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}