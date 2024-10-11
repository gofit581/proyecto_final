import 'package:entrenador/core/entities/Routine.dart';
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
      print('Error: $e');
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
        'image': routine.image,
        'rest': routine.rest,
        'observationsPerDay': routine.observationsPerDay,
        'traininDays': routine.trainingDays,
        'exercise': routine.exercises
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }
}
