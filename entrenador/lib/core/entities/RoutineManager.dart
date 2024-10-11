import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/presentation/provider/exercises_provider.dart';
import 'package:entrenador/services/register_service.dart';
import 'package:entrenador/services/update_service.dart';

class RoutineManager {
  static RegisterService registerService = RegisterService();
  static UpdateService updateService = UpdateService();
  static List<Routine> _routines = [];


  void agregarRoutine(Routine routine) {
    _routines.add(routine);
  }



    Future<void> addRoutine(Routine routine, Trainer trainer) async {
     //Routine newRoutine =_routines.where((routine)=>routine.id == routine.id) as Routine;
     print('LLEGUE ACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    await registerService.createRoutine(routine);
  }

/*     Future<void> addTrainerRoutine(Routine routine, Trainer trainer) async {
    await registerService.addTrainerRoutine(routine,trainer);
  } */

}