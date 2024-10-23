import 'package:alumno/core/entities/Notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final String baseUrl = 'https://670f0efd3e71518616566eaf.mockapi.io';

 Future<List<Notification>> getNotifications() async {
    final response = await http.get(Uri.parse('$baseUrl/Notification'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Notification.fromJson(data)).toList();
    } else {
      throw Exception('Error al cargar las notificaciones');
    }
  }
  
  Future<void> addNotification(Notification notification) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Notification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        notification.toJson()
      ),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al agregar la notificación');
    }
  }


  /*
  Future<void> deleteNotification(String idTrainer) async {
    final url = '$baseUrl/Notification/$idTrainer'; 
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la notificación');
    }
  }*/
}