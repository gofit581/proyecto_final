import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/entities/User.dart';
import '../core/entities/UserManager.dart';
class AuthService {
  final UserManager _userManager;

  AuthService(this._userManager);

  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<bool> loginAndSetUser(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        for (var userData in users) {
          if (userData['mail'] == email && userData['password'] == password) {
            final userOK = Usuario(
              id: userData['id'],
              mail: userData['mail'],
              userName: userData['userName'],
              password: userData['password'],
              age: userData['age'],
              idTrainer: userData['idTrainer'],
              objectiveDescription: userData['objetiveDescription'],
              experience: userData['experience'],
              discipline: userData['discipline'],
              trainingDays: userData['trainingDays'],
              trainingDuration: userData['trainingDuration'],
              injuries: userData['injuries'],
              extraActivities: userData['extraActivities'],
            );

            _userManager.setLoggedUser(userOK);
            _userManager.agregarUsuario(userOK);
            return true;
          }
        }
        throw Exception('User not found. Users: ${_userManager.getLoggedUser()}');
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      // Manejo de excepciones
      print('Error: $e');
      return false; // Opcional: vuelve a lanzar la excepción si necesitas manejarla en otro lugar
    }
  }

  Future<bool> searchIdTrainer(String idTrainter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Trainer'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        bool result = false;
        for (var userData in users) {
          if (userData['trainerCode'] == idTrainter) {
            result = true;
          }
        }
        return result;
      } else {
        throw Exception('IdTrainer not found');
      }
    } catch (e) {
      print('Error: $e');
      return true;
    }  
  }

  Future<bool> validateMail(String mail) async{
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
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
      print('Error: $e');
      return true;
    }  
  }
}