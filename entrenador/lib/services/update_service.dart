import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/User.dart';
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
        'age': usuario.age,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }
  
  Future<bool> saveRoutineForUser(Usuario alumno) async {
    try {
      final url = Uri.parse('$baseUrl/user/${alumno.id}');
      Map<String, dynamic> updateJson = {
        'userName': alumno.userName,
        'password': alumno.password,
        'mail': alumno.mail,
        'age': alumno.age,
        'idTrainer': alumno.idTrainer,
        'objectiveDescription': alumno.objectiveDescription,
        'experience': alumno.experience,
        'discipline': alumno.discipline,
        'trainingDays': alumno.trainingDays,
        'trainingDuration': alumno.trainingDuration,
        'injuries': alumno.injuries,
        'extraActivities': alumno.extraActivities,
        'currentRoutine': alumno.currentRoutine?.toJson(),
        'actualSesion': 0,
        'id': alumno.id
      };
      // ignore: avoid_print
      print('Datos a enviar: ${jsonEncode(updateJson)}');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateJson),
      );
      if (response.statusCode == 200) {
          return true;
        } else {
           // ignore: avoid_print
           print('Error al guardar la rutina: ${response.statusCode}, ${response.body}');
          return false;
        }
    } catch (e) {
      // ignore: avoid_print
      print('Error en la solicitud: $e');
      return false;
    }
  }

  Future<void> updateRegisterUser(Trainer usuario) async {
      final response = await http.put(
        Uri.parse('$baseUrl/Trainer/${usuario.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': usuario.userName,
          'agenda': usuario.agenda,
          'diasLaborales': usuario.diasLaborales,
          'duracionClasesMinutos': usuario.duracionClasesMinutos,
          'trabajaDesdeHora': usuario.trabajaDesdeHora,
          'trabajaHastaHora': usuario.trabajaHastaHora,
          'precioPorClase': usuario.precioPorClase,
        }),
      );
    if(response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }
}