import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:entrenador/presentation/clases_dia_screen.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:go_router/go_router.dart';

class CalendarioScreen extends StatefulWidget {
  static const String name = 'CalendarioScreen';
  final TrainerManager manager = TrainerManager();

  CalendarioScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _unreadNotificationsCount = 0;
  final NotificationService _notificationService = NotificationService();
  Trainer? _loggedTrainer;

  @override
  void initState() {
    super.initState();
    _loggedTrainer = widget.manager.getLoggedUser();
    if (_loggedTrainer != null) {
      _fetchUnreadNotifications();
    }
  }

  Future<void> _fetchUnreadNotifications() async {
    final notifications = await _notificationService
        .getUnreadNotifications(_loggedTrainer!.trainerCode);
    setState(() {
      _unreadNotificationsCount = notifications.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    _fetchUnreadNotifications();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calendario',
        actions: [
          IconButton(
            icon: _unreadNotificationsCount > 0
                ? const Icon(Icons.notification_important_sharp)
                : const Icon(Icons.notifications_none),
            color: _unreadNotificationsCount > 0
                ? const Color.fromARGB(255, 6, 152, 69)
                : const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTableCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'es_ES', 
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        // Navega a la vista clases_dia_screen.dart
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClasesDiaScreen(
                date: selectedDay), // Pasamos la fecha seleccionada
          ),
        );
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
