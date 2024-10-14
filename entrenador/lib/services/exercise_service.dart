import 'package:entrenador/core/entities/Exercise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseService {
  final String baseUrl = 'https://670be1387e5a228ec1ceeafb.mockapi.io/';
 
  Future<void> createExercise(Exercise exercise) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Ejercicio'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': exercise.title,
        'imageLink': exercise.imageLink,
        'description': exercise.description,
        'series': 0,
        'repetitions': 0,
        'done': false,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }
 }