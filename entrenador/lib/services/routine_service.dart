import 'package:entrenador/core/entities/Routine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutineService {
  final String baseUrl = 'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api';

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
        'observationsPerDay':routine.observationsPerDay,
        'traininDays':routine.trainingDays,
        'exercise':routine.exercises
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }
}
