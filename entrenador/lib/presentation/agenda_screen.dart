import 'package:flutter/material.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

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
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text("End Date: ${_endDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            SizedBox(height: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}