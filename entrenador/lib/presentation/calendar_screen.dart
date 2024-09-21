import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';

class CalendarioScreen extends StatefulWidget {
  static const String name = 'CalendarioScreen';
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
      appBar: CustomAppBar(
        title: 'Calendario',
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
      body: _buildTableCalendar(),
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => FechaScreen(fecha: selectedDay),
        //   ),
        // );
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