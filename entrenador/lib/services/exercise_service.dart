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
        'idTrainer': exercise.idTrainer,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }

    Future<List<Exercise>> getExercisesByTrainerId(String trainerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Ejercicio'),
        headers: {'Content-Type': 'application/json'},
      );

      // ignore: avoid_print
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> exercisesData = jsonDecode(response.body);
        final List<Exercise> exercises = exercisesData       
            .where((exercisesData) {
              return exercisesData['idTrainer'] == trainerId;
            })
            .map((exercisesData) => Exercise.fromJson(exercisesData))
            .toList();
        // ignore: avoid_print
        print('raw query$exercisesData');

        return exercises;
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Routine Error: $e');
      rethrow;
    }
  }

  Future<List<Exercise>> getExercises() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Ejercicio'),
        headers: {'Content-Type': 'application/json'},
      );
      // ignore: avoid_print
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {      
        final List<dynamic> exercisesData = jsonDecode(response.body);
        final List<Exercise> exercises = exercisesData
            .map((exercisesData) => Exercise.fromJson(exercisesData))
            .toList();
        // ignore: avoid_print
        print('raw query$exercisesData');

        return exercises;
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Routine Error: $e');
      rethrow;
    }
  }

    Future<bool> validateExercise(String title, String trainerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Ejercicio'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> exercisesData = jsonDecode(response.body);
        final List<Exercise> exercises = exercisesData       
            .where((exercisesData) {
              return exercisesData['idTrainer'] == trainerId;
            })
            .map((exercisesData) => Exercise.fromJson(exercisesData))
            .toList();

        bool result = false;

        for (var exercise in exercises) {
          if (exercise.title == title) {
            result = true;
          }
        }
        return result;
      } else {
        throw Exception('Exercises title not available');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Auth Error: $e');
      return true;
    }
  }
 }