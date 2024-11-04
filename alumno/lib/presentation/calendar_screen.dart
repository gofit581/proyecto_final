// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:alumno/widget/custom_app_bar.dart';
// import 'package:alumno/widget/custom_botton_navigation_bar.dart';

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
//       bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
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

import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/widget/custom_botton_navigation_bar.dart';
import 'package:alumno/presentation/clases_screen.dart'; // Asegúrate de importar ClasesScreen

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
  Usuario? actualUsuario;
  late int totalDays;
  late double progress;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
  setState(() {
    actualUsuario = UserManager().getLoggedUser();
    if (actualUsuario != null) {
      final userRoutine = actualUsuario?.actualRoutine;
      if (userRoutine != null) {
        totalDays = ((userRoutine.duration)! * (userRoutine.trainingDays!));
        progress = (actualUsuario!.actualSesion / totalDays);
      }      
    }
  });
}
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
            Text(
              'HOLA ${actualUsuario?.userName.toUpperCase()}!',
              style: const TextStyle(             
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              )
            ),
            const SizedBox(height: 40),
            const Text(
              'PROGRESO DE LA RUTINA',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 25,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color:const Color.fromARGB(255, 22, 22, 180),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'DÍA ${actualUsuario!.actualSesion} DE $totalDays',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 40),
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

        // Navegamos a ClasesScreen pasando el día seleccionado como parámetro
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClasesScreen(date: selectedDay), // Pasamos la fecha seleccionada
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
