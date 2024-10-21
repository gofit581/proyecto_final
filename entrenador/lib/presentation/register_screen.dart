import 'package:date_format/date_format.dart';
import 'package:entrenador/presentation/login_screen.dart';
import 'package:entrenador/presentation/register_entrenador_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String name = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _registerUserTFController = TextEditingController();
  final TextEditingController _registerPasswordTFController = TextEditingController();
  final TextEditingController _registerConfirmedPasswordTFController = TextEditingController();
  final TextEditingController _registerMailTFController = TextEditingController();
  final TextEditingController _registerAgeTFController = TextEditingController();
  final TextEditingController _registerIdTrainerTFController = TextEditingController();

  final TrainerManager trainerManager = TrainerManager();
  DateTime? _selectedDate;

  bool validateEmail(String? value) {
    bool result = true;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (value != null && value.isNotEmpty) {
      if (emailRegex.hasMatch(value)) {
        result = false;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/image/gofit-logo.jpg',
                    width: 200,
                    height: 200,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _registerUserTFController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Nombre y Apellido',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _registerAgeTFController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        border: InputBorder.none,
                        hintText: _selectedDate != null
                            ? 'Fecha de nacimiento: ${formatDate(_selectedDate!, [yyyy, '-', mm, '-', dd])}'
                            : 'DD/MM/AAAA',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1800),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _registerAgeTFController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _registerMailTFController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    controller: _registerPasswordTFController,
                    decoration: const InputDecoration(
                      hintText: 'Contraseña',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    controller: _registerConfirmedPasswordTFController,
                    decoration: const InputDecoration(
                      hintText: 'Confirme su contraseña',
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _registerIdTrainerTFController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Crea tu Codigo de Entrenador',
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    if (_registerUserTFController.text.isEmpty ||
                        _registerPasswordTFController.text.isEmpty ||
                        _registerConfirmedPasswordTFController.text.isEmpty ||
                        _registerMailTFController.text.isEmpty ||
                        _registerAgeTFController.text.isEmpty || _registerIdTrainerTFController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingrese todos los campos'),
                        ),
                      );
                    } else if (_registerPasswordTFController.text != _registerConfirmedPasswordTFController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, verifique su contraseña'),
                        ),
                      );
                    } else if (validateEmail(_registerMailTFController.text) || await trainerManager.validateMail(_registerMailTFController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingrese un email valido'),
                        ),
                      );
                    } else if(await trainerManager.validateId(_registerIdTrainerTFController.text)){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Codigo no disponible, por favor intentelo de nuevo'),
                          ),
                        );
                    } else {
                      if (_selectedDate!.isAfter(DateTime.now()) ||
                          (_selectedDate!.year == DateTime.now().year &&
                              _selectedDate!.month == DateTime.now().month &&
                              _selectedDate!.day == DateTime.now().day)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, ingrese una edad válida'),
                          ),
                        );
                        return;
                      }

                      Trainer trainer = Trainer.parcial(
                        userName: _registerUserTFController.text,
                        password: _registerPasswordTFController.text,
                        mail: _registerMailTFController.text,
                        age: _registerAgeTFController.text,
                        trainerCode: _registerIdTrainerTFController.text,
                      );

                      try {
                        context.goNamed(RegisterEntrenadorDataScreen.name, extra: trainer);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al registrar usuario: $e'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Continuar'),
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
                        child: const Text('Inicia Sesión', style: TextStyle(decoration: TextDecoration.underline ,fontSize: 16, color: Color.fromARGB(255, 22, 22, 180), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}