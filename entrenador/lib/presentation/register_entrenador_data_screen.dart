import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/presentation/agenda_screen.dart';
import 'package:entrenador/presentation/login_screen.dart';
import 'package:entrenador/services/update_service.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:go_router/go_router.dart';

class RegisterEntrenadorDataScreen extends StatelessWidget {
  static const String name = 'RegisterEntrenadorDataScreen';
  final Trainer trainer;

  RegisterEntrenadorDataScreen({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tus datos'),
      body: _Formulario(trainer: trainer),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}

class _Formulario extends StatefulWidget {
  const _Formulario({
    super.key,
    required this.trainer,
  });

  final Trainer trainer;

  @override
  State<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<_Formulario> {
  late final DateTime inicio;
  late final DateTime fin;
  final TrainerManager trainerManager = TrainerManager();
  final UpdateService updateService = UpdateService();
  final TextEditingController _registerDuracionController =
      TextEditingController();
  final TextEditingController _registerPrecioController =
      TextEditingController();
  final TextEditingController _registerTrabajaDesdeController =
      TextEditingController();
  final TextEditingController _registerTrabajaHastaController =
      TextEditingController();

  final List<String> dias = [
    'Domingo',
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sabado'
  ];

  @override
  void initState() {
    super.initState();
    widget.trainer.diasLaborales ??= [];
  }

  void agregarClaseAAgenda() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: _registerPrecioController,
                decoration: const InputDecoration(hintText: 'Precio por clase'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _registerDuracionController,
                decoration: const InputDecoration(
                    hintText: 'Duración de las clases en minutos'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _registerTrabajaDesdeController,
                      decoration:
                          const InputDecoration(hintText: 'Trabaja desde'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Hasta'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _registerTrabajaHastaController,
                      /*
                        decoration: InputDecoration(
                          labelText: 'Trabaja hasta',
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          )
                        ),*/
                      decoration:
                          const InputDecoration(hintText: 'Trabaja hasta'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Column(children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Espaciado
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: const Text(
                        'Selecciona los días que quieres trabajar:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold, // Negrita para resaltar
                        ),
                      ),
                    ),
                    Column(
                      children: List.generate(dias.length, (index) {
                        return CheckboxListTile(
                          title: Text(dias[index]),
                          value: widget.trainer.diasLaborales?.contains(index),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                // Agregar el día seleccionado
                                widget.trainer.diasLaborales?.add(index);
                              } else {
                                // Quitar el día deseleccionado
                                widget.trainer.diasLaborales?.remove(index);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_registerPrecioController.text.isEmpty ||
                    _registerDuracionController.text.isEmpty ||
                    _registerTrabajaDesdeController.text.isEmpty ||
                    _registerTrabajaHastaController.text.isEmpty ||
                    widget.trainer.diasLaborales == null ||
                    widget.trainer.diasLaborales!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingrese todos los campos'),
                    ),
                  );
                } else {
                  Trainer newTrainer = Trainer(
                    userName: widget.trainer.userName,
                    password: widget.trainer.password,
                    mail: widget.trainer.mail,
                    age: widget.trainer.age,
                    trainerCode: widget.trainer.trainerCode,
                    agenda: [],
                    routines: [],
                    diasLaborales: widget.trainer.diasLaborales,
                    duracionClasesMinutos:
                        int.tryParse(_registerDuracionController.text),
                    trabajaDesdeHora:
                        int.tryParse(_registerTrabajaDesdeController.text),
                    trabajaHastaHora:
                        int.tryParse(_registerTrabajaHastaController.text),
                    precioPorClase:
                        double.tryParse(_registerPrecioController.text),
                  );

                  try {
                    await trainerManager.registerUser(newTrainer);
                    trainerManager.setLoggedUser(newTrainer);
                    context.goNamed(AgendaScreen.name);
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Ya tenes una cuenta?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed(LoginScreen.name);
                    },
                    child: const Text('Inicia Sesión',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: Color.fromARGB(255, 22, 22, 180),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
