import 'package:entrenador/core/app_router.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/presentation/create_routine_screen.dart';
import 'package:entrenador/services/routine_service.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListRoutine extends StatefulWidget {
  const ListRoutine({super.key});
  static const String name = 'ListRoutine';

  @override
  State<ListRoutine> createState() => _ListRoutineState();
}

class _ListRoutineState extends State<ListRoutine> {
  late Future<List<Routine>> _routinesFuture;
  final RoutineService _routineService = RoutineService();
  Trainer? _loggedTrainer;

  @override
  void initState() {
    super.initState();
    _loggedTrainer = TrainerManager().getLoggedUser();
    if (_loggedTrainer != null) {
      _routinesFuture = _routineService.getRoutinesByTrainerId(_loggedTrainer!.trainerCode);
    } else {
      _routinesFuture = Future.error('No trainer logged in');
    }
  }

  Future<void> deleteRoutine(String idRoutine) async {
    try {
      bool? confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro que deseas eliminar esta rutina?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );
      print('confirmed: $confirmed');
      if (confirmed == true) {
          await _routineService.deleteRoutineById(idRoutine); 
          setState(() {
            _routinesFuture = _routineService.getRoutinesByTrainerId(_loggedTrainer!.trainerCode);//refresca la lista
          });
      }
    } catch (e) {
      print('Error al eliminar la rutina: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Lista de Rutinas',
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
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
            List<Routine> routines = snapshot.data!;
            return ListView.builder(
              itemCount: routines.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        routines[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(450, 33, 150, 243)),
                            onPressed: () {
                              // context.push(EditRoutine.name, extra: routines[index]);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              deleteRoutine(routines[index].id!);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/createRoutine');
        },
        backgroundColor: const Color.fromARGB(450, 33, 150, 243),
        child: const Icon(Icons.add),
      ),
    );
  }
}