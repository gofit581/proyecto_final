import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/services/routine_service.dart';
import 'package:entrenador/services/update_service.dart';

class RoutineManager {
  static UpdateService updateService = UpdateService();
  static List<Routine> _routines = [];
  static RoutineService routineService = RoutineService();


  void agregarRoutine(Routine routine) {
    _routines.add(routine);
  }



    Future<void> addRoutine(Routine routine, Trainer trainer) async {
    await routineService.createRoutine(routine);
  }

  Future<void> editRoutine(Routine newRoutine, String routineId) async {
    await routineService.editRoutine(newRoutine, routineId);
  }

}