import 'package:entrenador/core/entities/CustomNotification.dart';
import 'package:entrenador/core/entities/TypeOfNotification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final String baseUrl = 'https://670f0efd3e71518616566eaf.mockapi.io';

  Future<List<CustomNotification>> getUnreadNotifications(String trainerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Notification'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = jsonDecode(response.body);
        final List<CustomNotification> notifications = notificationsData
            .where((notificationData) => notificationData['idTrainer'] == trainerId 
            && notificationData['visto'] == false
            )
            .map((userData) => CustomNotification(
                  idAlumno: userData['idAlumno'],
                  idTrainer: userData['idTrainer'],
                  typeOfNotification: userData['typeOfNotification'] != null
                  ? TypeOfNotification.values.firstWhere(
                    (e) => e.toString().split('.').last == userData['typeOfNotification'],
                    orElse: () => TypeOfNotification.newUser)
                    : TypeOfNotification.newUser,
                  visto: userData['visto'],
                  id: userData['id'],
                ))
            .toList();
        return notifications;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Notification getting Error: $e');
      rethrow;
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

  Future<void> markAsRead(String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Notification/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'visto': true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al marcar la notificación como leída');
    }
  }
}