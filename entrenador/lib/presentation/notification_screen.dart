import 'package:entrenador/presentation/student_profile_screen.dart';
import 'package:entrenador/services/notification_service.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/core/entities/CustomNotification.dart';

class NotificationScreen extends StatefulWidget {
  static const String name = 'NotificationScreen';
  const NotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<CustomNotification>> _notificationFuture;
  final NotificationService _notificationService = NotificationService();
  Trainer? _loggedTrainer;

  @override
  void initState() {
    super.initState();
    _loggedTrainer = TrainerManager().getLoggedUser();
    if (_loggedTrainer != null) {
      _notificationFuture = _notificationService
          .getUnreadNotifications(_loggedTrainer!.trainerCode);
    } else {
      _notificationFuture = Future.error('Ningún entrenador ha iniciado sesión');
    }
  }

  void _showOptions(
      BuildContext context, CustomNotification notification, Usuario alumno) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Ver Alumno'),
              onTap: () {
                NotificationService().markAsRead(notification.id);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentProfileScreen(usuarioSeleccionado: alumno),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Marcar como leído'),
              onTap: () {
                NotificationService().markAsRead(notification.id);
                setState(() {
                  _notificationFuture = _notificationService
                      .getUnreadNotifications(_loggedTrainer!.trainerCode);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Mis Notificaciones'),
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: FutureBuilder<List<CustomNotification>>(
        future: _notificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tenes notificaciones nuevas'));
          } else {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return FutureBuilder<Usuario>(
                  future: notification.getAlumno(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(
                        leading: Icon(Icons.notifications_active),
                        title: Text('Cargando...'),
                      );
                    } else if (userSnapshot.hasError) {
                      return ListTile(
                        leading: const Icon(Icons.notifications_active),
                        title: Text('Error: ${userSnapshot.error}'),
                      );
                    } else if (!userSnapshot.hasData) {
                      return const ListTile(
                        leading: Icon(Icons.notifications_active),
                        title: Text('No se encontró el alumno'),
                      );
                    } else {
                      final alumno = userSnapshot.data!;
                      return ListTile(
                        leading: const Icon(Icons.notifications_active),
                        title: Text(
                            '${alumno.userName} ${notification.getMessage()}'),
                        onTap: () {
                          _showOptions(context, notification, alumno);
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
