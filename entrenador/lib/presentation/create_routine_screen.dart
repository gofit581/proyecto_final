import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/presentation/provider/exercises_provider.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateRoutineScreen extends ConsumerStatefulWidget {

  static const String name = 'CreateRoutineScreen';
  /*final Usuario actualUser;*/

  //SI EL ACTUALUSER ES NULL, ENTONCES QUE ME APAREZCA LA BARRA PARA COMPLETAR LA CANTIDAD DE DIAS POR SEMANA

  const CreateRoutineScreen({super.key/*, required this.actualUser*/});

  @override
  ConsumerState<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends ConsumerState<CreateRoutineScreen> {

  final TextEditingController _routineTypeOfTrainingController = TextEditingController();
  final TextEditingController _routineTitleController = TextEditingController();
  final TextEditingController _routineDurationController = TextEditingController();
  final TextEditingController _routineDaysController = TextEditingController();
  final TextEditingController _routineRestController = TextEditingController();
  List<TypeOfTraining> typeOfTraining = TypeOfTraining.values;
  TypeOfTraining selectedTraining = TypeOfTraining.LoseWeight;
  late TypeOfTraining aim;
  Usuario actualUser = Usuario.parcial(userName: 'Pepe', password: '1', mail: '1', age: '3', idTrainer: '1', trainingDays: '3', timesDone: [], actualSesion: 0);

  @override
  void initState() {
    super.initState();
    _routineTypeOfTrainingController.text = selectedTraining.name;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Crear rutina',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
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
                controller: _routineDaysController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Dias de entrenamiento por semana',
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
                  labelText: 'Tiempo de descanso entre ejercicios(segundos)',
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
                      typeOfTraining: selectedTraining,
                      rest: int.parse(_routineRestController.text),
                      trainingDays : int.parse(_routineDaysController.text),
                    );

                    ref.read(exercisesNotifierProvider.notifier).initializeRoutine(int.parse(_routineDurationController.text), int.parse(_routineDaysController.text));
                        context.push('/createRoutine2',                          
                          extra: routine);

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