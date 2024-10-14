import 'package:alumno/core/entities/Clase.dart';
import 'package:alumno/core/entities/Entrenador.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/entities/User.dart';
import '../core/entities/UserManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final UserManager _userManager;

  AuthService(this._userManager);

  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';
  final String baseTrainerUrl =
      'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  // Future<bool> loginAndSetUser(String email, String password) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/user'),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> users = jsonDecode(response.body);
  //       for (var userData in users) {
  //         if (userData['mail'] == email && userData['password'] == password) {
  //           final userOK = Usuario(
  //             id: userData['id'],
  //             mail: userData['mail'],
  //             userName: userData['userName'],
  //             password: userData['password'],
  //             age: userData['age'],
  //             idTrainer: userData['idTrainer'],
  //             objectiveDescription: userData['objetiveDescription'],
  //             experience: userData['experience'],
  //             discipline: userData['discipline'],
  //             trainingDays: userData['trainingDays'],
  //             trainingDuration: userData['trainingDuration'],
  //             injuries: userData['injuries'],
  //             extraActivities: userData['extraActivities'],
  //           );

  //           _userManager.setLoggedUser(userOK);
  //           _userManager.agregarUsuario(userOK);
  //           return true;
  //         }
  //       }
  //       throw Exception('User not found. Users: ${_userManager.getLoggedUser()}');
  //     } else {
  //       throw Exception('Failed to load users');
  //     }
  //   } catch (e) {
  //     // Manejo de excepciones
  //     print('Error: $e');
  //     return false; // Opcional: vuelve a lanzar la excepción si necesitas manejarla en otro lugar
  //   }
  // }

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
      print('Error: $e');
      return false;
    }
  }

  Future<Entrenador> crearEntrenador(String trainerCode) async {
    // Obtener el objeto Entrenador del API usando el trainerCode
    final response = await http.get(
      Uri.parse('$baseTrainerUrl/Trainer'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> trainers = jsonDecode(response.body);

      // Filtrar el entrenador que coincida con el trainerCode
      final entrenadorData = trainers.firstWhere(
        (trainer) => trainer['trainerCode'] == trainerCode,
        orElse: () => throw Exception('Trainer not found'),
      );

      // Crear el objeto Entrenador
      final entrenador = Entrenador(
        id: entrenadorData['id'],
        nombre: entrenadorData['userName'],
        apellido: '', // Si no hay un campo apellido en la API, dejar vacío o asignar otro valor
        alumnos: [], // Asignar una lista vacía o mapear los alumnos si están disponibles
        agenda: await obtenerAgendaClases(entrenadorData['id']),
        rutinas: [], // Asignar las rutinas si están disponibles en los datos de la API
        ejercicios: [], // Asignar los ejercicios si existen en los datos de la API
      );

      return entrenador;
    } else {
      throw Exception('Failed to load trainer data');
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

  // Función para guardar el userId en SharedPreferences
  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  // Función para obtener el userId desde SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
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
      print('Error: $e');
      return true;
    }
  }
}
