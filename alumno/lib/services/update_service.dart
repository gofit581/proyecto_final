import 'package:alumno/core/entities/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateService {
  final String baseUrl = 'https://665887705c3617052648e130.mockapi.io/api';

  Future<void> updateUser(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': usuario.userName,
        'password': usuario.password,
        'mail': usuario.mail,
        'age': usuario.age,
        //'training': usuario.training?.name,
        //'idCurrentRoutine': usuario.training?.index,
        //'timesDone': usuario.timesDone.map((e) => e.toIso8601String()).toList(),
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