import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/TypeOfTraining.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutineService {
  final String baseUrl = 'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api';

  Future<List<Routine>> getRoutinesByTrainerId(String trainerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Routine'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> routinesData = jsonDecode(response.body);
        final List<Routine> routines = routinesData       
            .where((routineData) {
              return routineData['idTrainer'] == trainerId;
            })
            .map((routineData) => Routine.fromJson(routineData))
            .toList();
        print('raw query' + routinesData.toString());

        return routines;
      } else {
        throw Exception('Failed to load routines');
      }
    } catch (e) {
      print('Routine Error: $e');
      rethrow;
    }
  }

  Future<void> deleteRoutineById(String routineId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Routine/$routineId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Rutina eliminada exitosamente');
    } else {
      throw Exception('Failed to delete routine');
    }
  }

  Future<void> createRoutine(Routine routine) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Routine'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': routine.title,
        'description': routine.description,
        'duration': routine.duration,
        'aim': routine.aim,
        'image':routine.image,
        'rest':routine.rest,
        'trainingDays':routine.trainingDays,
        'exercises': routine.exercises.map((week) => week.map((day) => day.toJson()).toList()).toList(),// A CHECKEAR
        'idTrainer':routine.idTrainer,
        'typeOfTraining':routine.typeOfTraining?.toJson(),
      }),
    );

    if (response.statusCode != 201) {
      print('Routine Error: ${response.body}');
      throw Exception('Failed to create routine');
    }
  }

Future<void> editRoutine(Routine newRoutine, String routineId) async {
  final response = await http.put(
    Uri.parse('$baseUrl/Routine/$routineId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': newRoutine.title,
      'description': newRoutine.description,
      'duration': newRoutine.duration,
      'aim': newRoutine.aim,
      'image': newRoutine.image,
      'rest': newRoutine.rest,
      'trainingDays': newRoutine.trainingDays,
      'exercises': newRoutine.exercises.map((week) => week.map((day) => day.toJson()).toList()).toList(),
      'idTrainer': newRoutine.idTrainer,
      'typeOfTraining': newRoutine.typeOfTraining?.toJson(),
    }),
  );

  if (response.statusCode != 200) {
    print('Edit Routine Error: ${response.body}');
    throw Exception('Failed to edit routine');
  } else {
    print('Routine updated successfully');
  }
}

  /*   Future<void> addTrainerRoutine(Routine routine, Trainer trainer) async{
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Trainer'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<Trainer> trainers = jsonDecode(response.body);
        for (var trainerData in trainers) {
          if (trainerData.id == trainer.id) {
            trainerData.addRoutine(routine);
            return;
          }
        }
      }
       
    } catch (e) {
      // Manejo de excepciones
      print('Error: $e'); 
    }

  } */

}