// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:entrenador/widget/custom_app_bar.dart';
// import 'package:entrenador/widget/custom_botton_navigation_bar.dart';

// class CalendarioScreen extends StatefulWidget {
//   static const String name = 'CalendarioScreen';

//   const CalendarioScreen({super.key});
//   @override
//   _CalendarioScreenState createState() => _CalendarioScreenState();
// }

// class _CalendarioScreenState extends State<CalendarioScreen> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'Calendario',
//       ),
//       bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildTableCalendar(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTableCalendar() {
//     return TableCalendar(
//       firstDay: DateTime.utc(2010, 10, 16),
//       lastDay: DateTime.utc(2030, 3, 14),
//       focusedDay: _focusedDay,
//       calendarFormat: _calendarFormat,
//       selectedDayPredicate: (day) {
//         return isSameDay(_selectedDay, day);
//       },
//       onDaySelected: (selectedDay, focusedDay) {
//         setState(() {
//           _selectedDay = selectedDay;
//           _focusedDay = focusedDay;
//         });
//       },
//       onFormatChanged: (format) {
//         if (_calendarFormat != format) {
//           setState(() {
//             _calendarFormat = format;
//           });
//         }
//       },
//       onPageChanged: (focusedDay) {
//         _focusedDay = focusedDay;
//       },
//     );
//   }
// }

import 'package:entrenador/core/entities/Trainer.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:entrenador/presentation/clases_dia_screen.dart'; 
import 'package:entrenador/core/entities/TrainerManager.dart';

class CalendarioScreen extends StatefulWidget {
  static const String name = 'CalendarioScreen';
  final TrainerManager manager = TrainerManager();     

  CalendarioScreen({super.key});
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
      appBar: const CustomAppBar(
        title: 'Calendario',
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
            builder: (context) => ClasesDiaScreen(date: selectedDay), // Pasamos la fecha seleccionada
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