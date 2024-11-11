import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/presentation/provider/exercises_provider.dart';
import 'package:entrenador/services/routine_service.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListRoutine extends ConsumerStatefulWidget {
  
  static const String name = 'ListRoutine';

  const ListRoutine({super.key});

  @override
  ConsumerState<ListRoutine> createState() => _ListRoutineState();
}

class _ListRoutineState extends ConsumerState<ListRoutine> {
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
      _routinesFuture = Future.error('Ningún entrenador ha iniciado sesión');
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
      // ignore: avoid_print
      print('confirmed: $confirmed');
      if (confirmed == true) {
          await _routineService.deleteRoutineById(idRoutine); 
          setState(() {
            _routinesFuture = _routineService.getRoutinesByTrainerId(_loggedTrainer!.trainerCode);//refresca la lista
          });
      }
    } catch (e) {
      // ignore: avoid_print
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
                          FloatingActionButton(
                            onPressed: () {
                              //ref.read(exercisesNotifierProvider.notifier).initializeRoutine(routines[index].duration, routines[index].trainingDays);
                              ref.read(exercisesNotifierProvider.notifier).useRoutine(routines[index].exercises);
                              context.push('/editRoutine', extra: routines[index]);
                            },
                            backgroundColor: Colors.blue[100],
                            child: const Icon(Icons.edit, color: Color.fromARGB(255, 22, 22, 180)),
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
                     Divider(
                      color: Colors.grey[300],
                      thickness: 0.5,
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
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
        backgroundColor:Colors.blue[100],
        child: const Icon(Icons.add, color: Color.fromARGB(255, 22, 22, 180)),
      ),
    );
  }
}