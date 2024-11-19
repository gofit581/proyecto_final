import 'dart:convert';
import 'package:alumno/core/entities/User.dart';
import 'package:http/http.dart' as http;

class AgendaService {
  final String claseEndpoint = 'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase';

  Future<bool> asignarAlumnoAClase(String idClase, Usuario alumno) async {
    try {
      // Convertir el objeto Usuario a JSON
      Map<String, dynamic> alumnoJson = {
  'id': alumno.id,
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
  'actualSesion': alumno.actualSesion,
  'currentRoutine': alumno.actualRoutine != null
      ? alumno.actualRoutine!.toJson() // Asumiendo que Routine tiene un método toJson
      : null,
};


      // Crear el payload con el alumno
      Map<String, dynamic> payload = {
        'alumno': alumnoJson,
      };

      // Hacer el PUT al endpoint
      final response = await http.put(
        Uri.parse('$claseEndpoint/$idClase'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 200) {
        print('Clase actualizada correctamente.');
        return true;
      } else {
        print('Error al actualizar la clase: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al asignar alumno a la clase: $e');
      return false;
    }
  }
}
