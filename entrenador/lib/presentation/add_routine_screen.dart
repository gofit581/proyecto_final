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
  // ignore: library_private_types_in_public_api
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
      _routinesFuture = Future.error('Ningún entrenador ha iniciado sesión');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const CustomAppBar(
      title: 'Agregar Rutina',
    ),
    backgroundColor: Colors.white,
    //bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    body: FutureBuilder<List<Routine>>(
      future: _routinesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron rutinas'));
        } else {
          final routines = snapshot.data!; // Obtiene la lista de rutinas

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: routines.length, // Cambia a routines.length
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            routines[index].title, // Accede al título de la rutina
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Checkbox(
                            value: selectedRoutineIndex == index, // Marca si coincide con el índice seleccionado
                            onChanged: (bool? value) {
                              setState(() {
                                selectedRoutineIndex = value! ? index : null; // Selecciona o desmarca la rutina
                              });
                            },
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedRoutineIndex != null) {
                          Routine selectedRoutine = routines[selectedRoutineIndex!];
                          widget.alumno.currentRoutine = selectedRoutine;

                          //print('Rutina seleccionada: ${selectedRoutine.title}');
                          
                          bool isSaved = await _updateService.saveRoutineForUser(widget.alumno);

                          if (isSaved) {   
                            // ignore: avoid_print
                            print('Rutina seleccionada: ${selectedRoutine.title}');
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Rutina asignada con éxito'),
                            ),
                            );
                            // ignore: use_build_context_synchronously
                            context.goNamed(UsersListScreen.name);                                                
                          } else {
                            // ignore: avoid_print
                            print('Error al guardar la rutina.');
                          }   
                        } else {
                          //print('No se ha seleccionado ninguna rutina.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se pudo asignar una rutina.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(450, 33, 150, 243),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          ),
                      
                      ),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () {
                        context.push('/createRoutine');
                      },
                      backgroundColor: const Color.fromARGB(450, 33, 150, 243),
                      child: const Icon(Icons.add),
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