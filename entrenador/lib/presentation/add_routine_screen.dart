import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/presentation/users_list_screen.dart';
import 'package:entrenador/services/routine_service.dart';
import 'package:entrenador/services/update_service.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:go_router/go_router.dart';

class AddRoutineScreen extends StatefulWidget {
  const AddRoutineScreen({super.key, required this.alumno});

  static const String name = 'AddRoutine';
  final Usuario alumno;
  
  @override
  _AddRoutineScreenState createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  int? selectedRoutineIndex;
  late Future<List<Routine>> _routinesFuture;
  final RoutineService _routineService = RoutineService();
  final UpdateService _updateService = UpdateService();
  Trainer? _loggedTrainer;

  @override
  void initState() {
    super.initState();
    _loggedTrainer = TrainerManager().getLoggedUser();
    if (_loggedTrainer != null) {
      _routinesFuture = _routineService.getRoutinesByTrainerId(_loggedTrainer!.trainerCode);
      //alumno = Usuario( )
      
    } else {
      _routinesFuture = Future.error('No trainer logged in');
    }
  }

  Widget build(BuildContext context) {
  final int alumnoTrainingDays = int.tryParse(widget.alumno.trainingDays) ?? 0;
  
  return Scaffold(
    appBar: const CustomAppBar(
      title: 'Agregar Rutina',
    ),
    backgroundColor: Colors.white,
    body: FutureBuilder<List<Routine>>(
      future: _routinesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.redAccent, fontSize: 16),
          ));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron rutinas', style: TextStyle(color: Colors.grey)));
        } else {
          final routines = snapshot.data!
              .where((routine) => routine.trainingDays == alumnoTrainingDays)
              .toList();

          return Column(
            children: [
              Padding(
               padding: const EdgeInsets.all(16.0),
                child: 
                Text(
                  'SELECCIONAR RUTINA PARA EL ALUMNO ${widget.alumno.userName.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: routines.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedRoutineIndex == index;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      color: isSelected ? Colors.blue[50] : Colors.blueGrey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          routines[index].title,
                          style: TextStyle(
                            fontSize: 18,
                            color: isSelected ? const Color.fromARGB(255, 22, 22, 180) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: Checkbox(
                          activeColor: Colors.blue.shade900,
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedRoutineIndex = value! ? index : null;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        if (selectedRoutineIndex != null) {
                          Routine selectedRoutine = routines[selectedRoutineIndex!];
                          widget.alumno.currentRoutine = selectedRoutine;

                          bool isSaved = await _updateService.saveRoutineForUser(widget.alumno);

                          if (isSaved) {
                            widget.alumno.resetSesions();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Rutina asignada con éxito'),
                                backgroundColor: Colors.green.shade400,
                              ),
                            );
                            context.goNamed(UsersListScreen.name);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al guardar la rutina'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      backgroundColor: Colors.blue[100],
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 22, 22, 180),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: () {
                        context.push('/createRoutine');
                      },
                      backgroundColor:Colors.blue[100],
                      child: const Icon(Icons.add, color: Color.fromARGB(255, 22, 22, 180)),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    ),
  );
}
}