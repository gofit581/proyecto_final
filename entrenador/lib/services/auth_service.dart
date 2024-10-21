import 'package:entrenador/core/entities/Clase.dart';
import 'package:entrenador/core/entities/RoutineManager.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final TrainerManager _trainerManager;

  AuthService(this._trainerManager);

  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<bool> loginAndSetUser(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Trainer'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        for (var userData in users) {
          if (userData['mail'] == email && userData['password'] == password) {
            var userOK = Trainer.parcial(
              id: userData['id'],
              mail: userData['mail'],
              userName: userData['userName'],
              password: userData['password'],
              age: userData['age'],
              trainerCode: userData['trainerCode']
            );

            if (userOK.id != null) {
              final agenda = await obtenerAgendaClases(userOK.id!);
              userOK.setAgenda(agenda);
            }

            _trainerManager.setLoggedUser(userOK);
            _trainerManager.agregarUsuario(userOK);
            return true;
          }
        }
        throw Exception('User not found. Users: ${_trainerManager.getLoggedUser()}');
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      // Manejo de excepciones
      print('Auth Error: $e');
      return true; // Opcional: vuelve a lanzar la excepción si necesitas manejarla en otro lugar
    }
  }

  // Método para obtener la agenda de clases desde la API
  Future<List<Clase>> obtenerAgendaClases(String idTrainer) async {
    final String claseEndpoint =
        'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase';
    final claseResponse = await http.get(
      Uri.parse(claseEndpoint),
      headers: {'Content-Type': 'application/json'},
    );

    if (claseResponse.statusCode == 200) {
      final List<dynamic> clasesData = jsonDecode(claseResponse.body);

      // Filtrar las clases que correspondan al idTrainer
      final List<Clase> agenda = clasesData
          .where(
              (claseData) => claseData['idTrainer'] == idTrainer)
          .map((claseData) => Clase(
                id: DateTime.fromMillisecondsSinceEpoch(
                    claseData['horaInicio'] * 1000),
                duracionHs: claseData['duracionHs'],
                alumno:
                    null, // Aquí puedes mapear el objeto alumno si está disponible
                precio: claseData['precio'].toDouble(),
              ))
          .toList();

      return agenda;
    } else {
      throw Exception('Failed to load class data');
    }
  }

  Future<bool> searchIdTrainer(String idTrainer) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Trainer'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        bool success = false;
        for (var userData in users) {
          if (userData['trainerCode'] == idTrainer) {
            success = true;
          }
        }
        return success;
      } else {
        throw Exception('IdTrainer not found');
      }
    } catch (e) {
      // Manejo de excepciones
      print('Auth Error: $e');
      return true; // Opcional: vuelve a lanzar la excepción si necesitas manejarla en otro lugar
    }
  }

    Future<bool> validateMail(String mail) async{
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Trainer'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        bool result = false;
        for (var userData in users) {
          if (userData['mail'] == mail){
            result = true;
          }
        }
        return result;
      } else {
        throw Exception('Mail not available');
      }
    } catch (e) {
      print('Auth Error: $e');
      return true;
    }  
  }
}