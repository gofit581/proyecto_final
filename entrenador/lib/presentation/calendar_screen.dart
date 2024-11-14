import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
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
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Hola ${_loggedTrainer!.userName}!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            _buildTableCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), 
          ),
        ],
        border: Border.all(
          color: const Color.fromARGB(255, 22, 22, 180),
          width: 2.0,
        ),
      ),
      child: TableCalendar(
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
          context.push('/clasesDia', extra: selectedDay);
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
      ),
    );
  }
}
