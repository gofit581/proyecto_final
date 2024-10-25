import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:go_router/go_router.dart';

class AgendaScreen extends StatefulWidget {
  static const String name = 'AgendaScreen';
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  TrainerManager manager = TrainerManager();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _enableAgenda() {
    if (_startDate != null && _endDate != null) {
      // Llama a TrainerManager para generar la agenda
      manager.generarAgenda(_startDate!, _endDate!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agenda enabled from ${_startDate!.toLocal()} to ${_endDate!.toLocal()}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Agenda Screen',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Start Date: ${_startDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text("End Date: ${_endDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
              _enableAgenda();
              context.goNamed(CalendarioScreen.name);
              },
              child: const Text('Enable Agenda'),
            ),
          ],
        ),
      ),
    );
 }
}




/*
import 'package:flutter/material.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  TrainerManager manager = TrainerManager();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Start Date: ${_startDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text("End Date: ${_endDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            SizedBox(height: 20),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_startDate != null && _endDate != null) {
                  // Handle the logic to enable the agenda
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Agenda enabled from ${_startDate!.toLocal()} to ${_endDate!.toLocal()}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select both start and end dates')),
                  );
                }
              },
              child: Text('Enable Agenda'),
                    const SnackBar(content: Text('Please select both start and end dates')),
                  );
                }
              },
              child: const Text('Enable Agenda'),
            ),
          ],
        ),
      ),
    );
  }
}
}
*/
