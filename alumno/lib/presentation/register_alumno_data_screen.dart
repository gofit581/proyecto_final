import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/internaData/user_data_options.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/services/update_service.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/entities/User.dart';

class RegisterAlumnoDataScreen extends StatefulWidget {
  static const String name = 'RegisterAlumnoDataScreen';
  final Usuario usuario;

  const RegisterAlumnoDataScreen({super.key, required this.usuario});

  @override
  State<RegisterAlumnoDataScreen> createState() => _RegisterAlumnoDataScreenState();
}

class _RegisterAlumnoDataScreenState extends State<RegisterAlumnoDataScreen> {
  final UserManager userManager = UserManager();
  final UpdateService updateService = UpdateService();
  late String selectedObjective;
  final TextEditingController _registerObjectiveTFController = TextEditingController();
  final TextEditingController _registerExperienceTFController = TextEditingController();
  final TextEditingController _registerDisciplineTFController = TextEditingController();
  final TextEditingController _registerDaysTFController = TextEditingController();
  final TextEditingController _registerTimeTFController = TextEditingController();
  final TextEditingController _registerInjuriesTFController = TextEditingController();
  final TextEditingController _registerExtraActivitiesTFController = TextEditingController();
  List<String> days = ['1', '2', '3', '4', '5', '6', '7'];
  late String selectedDays;

  @override
  void initState() {
    super.initState();
    selectedObjective = objectiveDescriptions.first;
    selectedDays = days.first;
  }

  @override
  Widget build(BuildContext context) {
    List<String> datos = objectiveDescriptions;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tus datos',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedObjective,
                decoration: InputDecoration(
                  labelText: 'Objetivos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: datos.map((dato) {
                  return DropdownMenuItem<String>(
                    value: dato,
                    child: Text(dato),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedObjective = value!;
                    _registerObjectiveTFController.text = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _registerDisciplineTFController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Disciplina que te gustaría realizar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _registerExperienceTFController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Experiencia previa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedDays,
                decoration: InputDecoration(
                  labelText: 'Dias disponibles para entrenar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: days.map((day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDays = value!;
                    _registerDaysTFController.text = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _registerTimeTFController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Tiempo disponible para entrenar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _registerInjuriesTFController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Molestias y/o lesiones a tener en cuenta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _registerExtraActivitiesTFController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: '¿Realizas otra actividad además de la nuestra?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_registerObjectiveTFController.text.isEmpty ||
                      _registerDisciplineTFController.text.isEmpty ||
                      _registerExperienceTFController.text.isEmpty ||
                      _registerDaysTFController.text.isEmpty ||
                      _registerTimeTFController.text.isEmpty ||
                      _registerInjuriesTFController.text.isEmpty ||
                      _registerExtraActivitiesTFController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, ingrese todos los campos'),
                      ),
                    );
                  } else {
                    Usuario newUser = Usuario(
                      userName: widget.usuario.userName,
                      password: widget.usuario.password,
                      mail: widget.usuario.mail,
                      age: widget.usuario.age,
                      idTrainer: widget.usuario.idTrainer,
                      objectiveDescription: _registerObjectiveTFController.text,
                      experience: _registerExperienceTFController.text,
                      discipline: _registerDisciplineTFController.text,
                      trainingDays: _registerDaysTFController.text,
                      trainingDuration: _registerTimeTFController.text,
                      injuries: _registerInjuriesTFController.text,
                      extraActivities: _registerExtraActivitiesTFController.text,
                    );

                    try {
                      await userManager.registerUser(newUser);
                      userManager.setLoggedUser(newUser);
                      context.goNamed(CalendarioScreen.name, extra: newUser);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al registrar usuario: $e'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}