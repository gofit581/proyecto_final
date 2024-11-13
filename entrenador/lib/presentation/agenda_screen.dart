import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:go_router/go_router.dart';

class AgendaScreen extends StatefulWidget {
  static const String name = 'AgendaScreen';

  const AgendaScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
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
      manager.generarAgenda(_startDate!, _endDate!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agenda habilitada desde ${_startDate!.toLocal()} hasta ${_endDate!.toLocal()}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor seleccione las fechas de inicio y finalización')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Agenda',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Fecha de inicio: ${_startDate?.toLocal().toString().split(' ')[0] ?? 'No seleccionado'}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text("Fecha de finalización: ${_endDate?.toLocal().toString().split(' ')[0] ?? 'No seleccionado'}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
              _enableAgenda();
              context.goNamed(CalendarioScreen.name);
              },
              child: const Text('Habilitar Agenda'),
            ),
          ],
        ),
      ),
    );
  }
}
