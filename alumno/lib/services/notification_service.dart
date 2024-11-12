import 'package:alumno/core/entities/CustomNotification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final String baseUrl = 'https://670f0efd3e71518616566eaf.mockapi.io';

 Future<List<CustomNotification>> getNotifications() async {
    final response = await http.get(Uri.parse('$baseUrl/Notification'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => CustomNotification.fromJson(data)).toList();
    } else {
      throw Exception('Error al cargar las notificaciones');
    }
  }
  
  Future<void> addNotification(CustomNotification notification) async {
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
}