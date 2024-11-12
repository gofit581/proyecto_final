import 'package:alumno/core/entities/Clase.dart';
import 'package:alumno/core/entities/Entrenador.dart';
import 'package:alumno/core/entities/Routine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/entities/User.dart';
import '../core/entities/UserManager.dart';

class AuthService {
  final UserManager _userManager;
  AuthService(this._userManager);

  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';
  final String baseTrainerUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

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
              objectiveDescription: userData['objectiveDescription'],
              experience: userData['experience'],
              discipline: userData['discipline'],
              trainingDays: userData['trainingDays'],
              trainingDuration: userData['trainingDuration'],
              injuries: userData['injuries'],
              extraActivities: userData['extraActivities'],
              actualSesion: userData['actualSesion'],
              actualRoutine:  userData['currentRoutine'] != null
                              ? Routine.fromJson(userData['currentRoutine'])
                              : null,
            );
            userOK.profesor = await crearEntrenador(userData['idTrainer']);

            _userManager.setLoggedUser(userOK);
            _userManager.agregarUsuario(userOK);
            return true;
          }
        }
        throw Exception(
            'User not found. Users: ${_userManager.getLoggedUser()}');
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Auth Error: $e');
      return false;
    }
  }

  Future<Entrenador> crearEntrenador(String trainerCode) async {
    final response = await http.get(
      Uri.parse('$baseTrainerUrl/Trainer'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> trainers = jsonDecode(response.body);
      final entrenadorData = trainers.firstWhere(
        (trainer) => trainer['trainerCode'] == trainerCode,
        orElse: () => throw Exception('Trainer not found'),
      );
      final entrenador = Entrenador(
        id: entrenadorData['id'],
        nombre: entrenadorData['userName'],
        apellido: '',
        alumnos: [], 
        agenda: await obtenerAgendaClases(trainerCode),
        rutinas: [], 
        ejercicios: [],
      );

      return entrenador;
    } else {
      throw Exception('Failed to load trainer data');
    }
  }

  Future<List<Clase>> obtenerAgendaClases(String idTrainer) async {
    const String claseEndpoint = 'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase';
    final claseResponse = await http.get(
      Uri.parse(claseEndpoint),
      headers: {'Content-Type': 'application/json'},
    );
    if (claseResponse.statusCode == 200) {
      final List<dynamic> clasesData = jsonDecode(claseResponse.body);
      final List<Clase> agenda = clasesData
          .where((claseData) => claseData['idTrainer'] == idTrainer)
          .map((claseData) => Clase(
                id: claseData['id'],
                horaInicio: DateTime.parse(claseData['horaInicio']),
                duracionHs: claseData['duracionHs'],
                alumno:
                    claseData['alumno'] != null ? Usuario.fromJson(claseData['alumno']) : null,
                precio: claseData['precio'].toDouble(),
              ))
          .toList();
      return agenda;
    } else {
      throw Exception('Failed to load class data');
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
      // ignore: avoid_print
      print('AuthError: $e');
      return true;
    }
  }

  Future<bool> validateMail(String mail) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        bool result = false;
        for (var userData in users) {
          if (userData['mail'] == mail) {
            result = true;
          }
        }
        return result;
      } else {
        throw Exception('Mail not available');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Auth Error: $e');
      return true;
    }
  }
    Future<bool> updateUser(Usuario updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/${updatedUser.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userName': updatedUser.userName,
          'password': updatedUser.password,
          'mail': updatedUser.mail,
          'age': updatedUser.age,
          'idTrainer': updatedUser.idTrainer,
          'objectiveDescription': updatedUser.objectiveDescription,
          'experience': updatedUser.experience,
          'discipline': updatedUser.discipline,
          'trainingDays': updatedUser.trainingDays,
          'trainingDuration': updatedUser.trainingDuration,
          'injuries': updatedUser.injuries,
          'extraActivities': updatedUser.extraActivities,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      // ignore: avoid_print
      print('Update User Error: $e');
      return false;
    }
  }
}
