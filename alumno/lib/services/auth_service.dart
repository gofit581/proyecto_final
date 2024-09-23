import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/entities/User.dart';
import '../core/entities/UserManager.dart';
class AuthService {
  final UserManager _userManager;

  AuthService(this._userManager);
  
  final String baseUrl = 'https://66d746e0006bfbe2e650640f.mockapi.io/api';

  Future<void> loginAndSetUser(String email, String password) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      for (var userData in users) {
        if (userData['mail'] == email && userData['password'] == password) {
/*           final int routineId = userData['idCurrentRoutine'];
          final routineResponse = await http.get(
            Uri.parse('$baseUrl/routines/$routineId'),
            headers: {'Content-Type': 'application/json'},
          ); 

          if (routineResponse.statusCode == 200) {
             final routineData = jsonDecode(routineResponse.body);

            List<Exercise> exercises = (routineData['exercises'] as List)
                .map((exerciseData) => Exercise(
                      title: exerciseData['title'],
                      imageLink: exerciseData['imageLink'],
                      description: exerciseData['description'],
                    ))
                .toList(); */

/*             final Routine routine = Routine(
              title: routineData['title'],
              description: routineData['description'],
              duration: routineData['duration'],
              exercises: exercises,
              aim: routineData['aim'],
              typeOfTraining: TypeOfTraining.values[routineId]
            ); */

            final userOK = Usuario.parcial(
              id: userData['id'],
              mail: userData['mail'],
              userName: userData['userName'],
              password: userData['password'],
              age: userData['age'],
              idTrainer: userData['idTrainer'],

              //training: userData['training'] != null
              //    ? TypeOfTraining.values.firstWhere(
              //        (type) => type.name == userData['training'],
              //       orElse: () => TypeOfTraining.values[0])
              //    : null,
              //urrentRoutine: routine,
              //timesDone: userData['timesDone'] != null
              //    ? (userData['timesDone'] as List)
              //        .map((time) => DateTime.parse(time))
              //        .toList()
              //    : [],
            );

            _userManager.setLoggedUser(userOK);
            _userManager.agregarUsuario(userOK);
            return;
          } else {
            throw Exception('Failed to load routine for user');
          }
        }
/*       }
      throw Exception('User not found. Users: ${_userManager.getLoggedUser()}'); */
    } else {
      throw Exception('Failed to load users');
    }
  }
}