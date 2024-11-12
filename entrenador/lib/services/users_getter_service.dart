import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/entities/User.dart';

class UsersGetterService {
  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<List<Usuario>> getUsersByTrainerId(String trainerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersData = jsonDecode(response.body);
        final List<Usuario> users = usersData
            .where((userData) => userData['idTrainer'] == trainerId)
            .map((userData) => Usuario(
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
                ))
            .toList();

            users.sort((a, b) => a.userName.compareTo(b.userName));

        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('User getting Error: $e');
      rethrow;
    }
  }

  Future<Usuario> getUserById(String id) async {
  final url = Uri.parse('$baseUrl/user/$id');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return Usuario.fromJson(data);
    } else {
      throw Exception('Error al obtener el usuario');
    }
  } catch (e) {
    print(e);
    throw Exception('Error al conectar con la API');
  }
}
}