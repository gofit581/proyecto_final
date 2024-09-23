import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final TrainerManager _userManager;

  AuthService(this._userManager);

  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<void> loginAndSetUser(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Trainer'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        for (var userData in users) {
          if (userData['mail'] == email && userData['password'] == password) {
            final userOK = Trainer(
              id: userData['id'],
              mail: userData['mail'],
              userName: userData['userName'],
              password: userData['password'],
              age: userData['age'],
            );

            _userManager.setLoggedUser(userOK);
            _userManager.agregarUsuario(userOK);
            return;
          }
        }
        throw Exception('User not found. Users: ${_userManager.getLoggedUser()}');
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      // Manejo de excepciones
      print('Error: $e');
      rethrow; // Opcional: vuelve a lanzar la excepción si necesitas manejarla en otro lugar
    }
  }
}