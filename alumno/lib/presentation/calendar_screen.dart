import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/widget/custom_botton_navigation_bar.dart';
import 'package:alumno/presentation/clases_screen.dart';


class CalendarioScreen extends StatefulWidget {
  static const String name = 'CalendarioScreen';

  const CalendarioScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Usuario? actualUsuario;
  late int totalDays;
  late double progress = 0;
  bool hasRoutine = false;

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
        hasRoutine = true;
      } 
      else
      {
        totalDays = 1;
        progress = 0;
        hasRoutine = false;
      }     
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: CustomAppBar(
        title: 'Hola ${actualUsuario?.userName}!',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTableCalendar(),
            const SizedBox(height: 40),
            Text(
              hasRoutine ? 'PROGRESO DE TU RUTINA' : 'No tenes una rutina activa',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
            const SizedBox(height: 5),
            Text(
              hasRoutine ? 'DÍA ${actualUsuario!.actualSesion} DE $totalDays' : '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClasesScreen(date: selectedDay),
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
      ),
    );
  }
}
