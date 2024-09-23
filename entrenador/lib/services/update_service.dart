import 'package:entrenador/core/entities/Trainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateService {
  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<void> updateUser(Trainer usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Trainer/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': usuario.userName,
        'password': usuario.password,
        'mail': usuario.mail,
        'age': usuario.age
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }
}