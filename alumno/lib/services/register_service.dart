import 'package:alumno/core/entities/TrainingDay.dart';
import 'package:alumno/core/entities/TypeOfTraining.dart';
import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/Routine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<void> registerUser(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': usuario.userName,
        'password': usuario.password,
        'mail': usuario.mail,
        'age': usuario.age,
        'idTrainer': usuario.idTrainer,
        'objectiveDescription': usuario.objectiveDescription,
        'experience': usuario.experience,
        'discipline': usuario.discipline,
        'trainingDays': usuario.trainingDays,
        'trainingDuration': usuario.trainingDuration ,
        'injuries': usuario.injuries,
        'extraActivities': usuario.extraActivities,
        'actualSesion': usuario.actualSesion,
        'currentRoutine': usuario.actualRoutine,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }

  Future<Routine> fetchRoutine2(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/routines/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch routine');
    }
    final routineData = jsonDecode(response.body);
    List<List<TrainingDay>> exercises = (routineData['exercises'] as List)
            .map((dayData) => (dayData as List)
                .map((exerciseJson) => TrainingDay.fromJson(exerciseJson))
                .toList())
            .toList();

    return Routine(
      title: routineData['title'],
      description: routineData['description'],
      duration: routineData['duration'],
      exercises: exercises,
      aim: routineData['aim'],
      typeOfTraining: routineData['typeOfTraining'].index,
      rest: routineData['rest'],
      idTrainer: routineData['idTrainer'],
      trainingDays: routineData['trainingDays'],
    );
  }

  Future<Routine> fetchRoutine(int typeOfRoutine) async {
    const baseUrl = 'https://665887705c3617052648e130.mockapi.io/api';
    final response = await http.get(Uri.parse('$baseUrl/routines?typeOfTraining=$typeOfRoutine'));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch routine');
    }
    final routineData = jsonDecode(response.body);
    final List<dynamic> routines = routineData is List ? routineData : [routineData];
    final routine = routines.first;

      List<List<TrainingDay>> exercises = (routineData['exercises'] as List)
            .map((dayData) => (dayData as List)
                .map((exerciseJson) => TrainingDay.fromJson(exerciseJson))
                .toList())
            .toList();

    return Routine(
      title: routine['title'],
      description: routine['description'],
      duration: routine['duration'],
      exercises: exercises,
      aim: routine['aim'],
      typeOfTraining: TypeOfTraining.values[typeOfRoutine],
      rest: routineData['rest'],
      idTrainer: routineData['idTrainer'],
      trainingDays: routineData['trainingDays'],
    );
  }
}