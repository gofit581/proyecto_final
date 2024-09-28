import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/widget/custom_botton_navigation_bar.dart';

class CalendarioScreen extends StatefulWidget {
  static const String name = 'CalendarioScreen';

  const CalendarioScreen({super.key});
  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: const CustomAppBar(
        title: 'Calendario',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
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