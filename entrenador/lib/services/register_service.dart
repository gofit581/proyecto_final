import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<void> registerUser(Trainer usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Trainer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': usuario.userName,
        'password': usuario.password,
        'mail': usuario.mail,
        'age': usuario.age,
        'trainerCode':usuario.trainerCode,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }

  final String baseUrl2 = 'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api';

  Future<void> createRoutine(Routine routine) async {
    print('TAMBIEN LLEGUE ACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    final response = await http.post(
      Uri.parse('$baseUrl2/Routine'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': routine.title,
        'description': routine.description,
        'duration': routine.duration,
        'aim': routine.aim,
        'image':routine.image,
        'rest':routine.rest,
        'observationsPerDay':routine.observationsPerDay,
        'trainingDays':routine.trainingDays,
        'exercises':routine.exercises.map((dayExercises) =>
          dayExercises.map((exercise) => exercise.toJson()).toList()).toList(),
      }),
    );

    if (response.statusCode != 201) {
      print('Error: ${response.body}');
      throw Exception('Failed to create routine');
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

  // Future<Routine> fetchRoutineByTrainingId(int typeOfTrainingId) async {
  //   // final response = await http.get(Uri.parse('$baseUrl/routines'));

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/routines'),
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to fetch routines');
  //   }

  //   final List<dynamic> routinesData = jsonDecode(response.body);

  //   // Buscar la rutina que coincida con el typeOfTrainingId
  //   final routineData = routinesData.firstWhere(
  //     (routine) => routine['typeOfTraining'] == typeOfTrainingId,
  //     orElse: () => throw Exception(
  //         'Routine not found for training id: $typeOfTrainingId, $routinesData'),
  //   );

  //   List<Exercise> exercises = (routineData['exercises'] as List)
  //       .map((exerciseData) => Exercise(
  //             title: exerciseData['title'],
  //             imageLink: exerciseData['imageLink'],
  //             description: exerciseData['description'],
  //           ))
  //       .toList();

  //   return Routine(
  //     title: routineData['title'],
  //     description: routineData['description'],
  //     duration: routineData['duration'],
  //     exercises: exercises,
  //     aim: routineData['aim'],
  //     typeOfTraining: routineData['typeOfTraining'],
  //   );
  // }
}