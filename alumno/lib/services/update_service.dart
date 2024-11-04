import 'package:alumno/core/entities/Routine.dart';
import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateService {

  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<void> updateUser(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/${usuario.id}'),
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
        'currentRoutine': usuario.actualRoutine != null ? 
        usuario.actualRoutine!.toJson() : [],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> updateRegisterUser(Usuario usuario) async {
        final response = await http.put(
      Uri.parse('$baseUrl/users/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': usuario.userName,
        'objetiveDescription' : usuario.objectiveDescription,
        'experience' : usuario.experience,
        'discipline' : usuario.discipline,
        'trainingDays' : usuario.trainingDays,
        'trainingDuration' : usuario.trainingDuration,
        'injuries' : usuario.injuries,
        'extraActivities' : usuario.extraActivities,
      }),
      );
      if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }


}