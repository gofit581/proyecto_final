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
        'agenda': usuario.agenda,
        'diasLaborales': usuario.diasLaborales,
        'duracionClasesMinutos': usuario.duracionClasesMinutos,
        'trabajaDesdeHora': usuario.trabajaDesdeHora,
        'trabajaHastaHora': usuario.trabajaHastaHora,
        'precioPorClase': usuario.precioPorClase,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }
}