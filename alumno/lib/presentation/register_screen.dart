import 'package:flutter/material.dart';
import 'package:alumno/presentation/login_screen.dart';
import 'package:alumno/presentation/register_alumno_data_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:go_router/go_router.dart';
import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String name = 'RegisterScreen';

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _registerUserTFController = TextEditingController();
  final TextEditingController _registerPasswordTFController = TextEditingController();
  final TextEditingController _registerConfirmedPasswordTFController = TextEditingController();
  final TextEditingController _registerMailTFController = TextEditingController();
  final TextEditingController _registerAgeTFController = TextEditingController();
  final TextEditingController _registerIdTrainerTFController = TextEditingController();
  final UserManager userManager = UserManager();
  DateTime? _selectedDate;

  bool _isPasswordVisible = false;
  bool _isConfirmedPasswordVisible = false;

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
                        border: InputBorder.none,
                        hintText: _selectedDate != null
                            ? 'Fecha de nacimiento: ${formatDate(_selectedDate!, [
                                    yyyy,
                                    '-',
                                    mm,
                                    '-',
                                    dd
                                  ])}'
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
                            _registerAgeTFController.text =
                                DateFormat('yyyy-MM-dd').format(_selectedDate!);
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
                    controller: _registerPasswordTFController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _registerConfirmedPasswordTFController,
                      obscureText: !_isConfirmedPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Confirme su contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmedPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmedPasswordVisible = !_isConfirmedPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text("Codigo de entrenador"),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: TextField(
                      controller: _registerIdTrainerTFController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
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
                        _registerAgeTFController.text.isEmpty ||
                        _registerIdTrainerTFController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingrese todos los campos'),
                        ),
                      );
                    } else if (_registerPasswordTFController.text !=
                        _registerConfirmedPasswordTFController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, verifique su contraseña'),
                        ),
                      );
                    } else if (validateEmail(_registerMailTFController.text) || await userManager.validateMail(_registerMailTFController.text)) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingrese un email valido'),
                        ),
                      );
                    } else if(!await userManager.validateId(_registerIdTrainerTFController.text)){
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Codigo de entrenador inexistente, por favor intentelo de nuevo'),
                          ),
                        );
                    
                    } else {
                      if (_selectedDate!.isAfter(DateTime.now()) ||
                          (_selectedDate!.year == DateTime.now().year &&
                              _selectedDate!.month == DateTime.now().month &&
                              _selectedDate!.day == DateTime.now().day)) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, ingrese una edad válida'),
                          ),
                        );
                        return;
                      }

                      Usuario usuario = Usuario.parcial(
                        userName: _registerUserTFController.text,
                        password: _registerPasswordTFController.text,
                        mail: _registerMailTFController.text,
                        age: _registerAgeTFController.text,
                        idTrainer: _registerIdTrainerTFController.text,
                        actualSesion: 0,
                      );

                      try {
                        // ignore: use_build_context_synchronously
                        context.goNamed(RegisterAlumnoDataScreen.name,
                            extra: usuario);
                      } catch (e) {
                        // ignore: use_build_context_synchronously
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
