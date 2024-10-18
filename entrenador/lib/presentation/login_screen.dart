// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/presentation/register_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'LoginScreen';

  LoginScreen({super.key});

  final TextEditingController _userTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();
  final TrainerManager userManager = TrainerManager();

  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _userTextFieldController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 92, 92, 92),
                    label: Text('Email'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _passwordVisible,
                  builder: (context, isObscured, child) {
                    return TextField(
                      controller: _passwordTextFieldController,
                      obscureText: isObscured,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 92, 92, 92),
                        label: Text('Contraseña'),
                        suffixIcon: GestureDetector(
                          onLongPress: () {
                            _passwordVisible.value = false;
                          },
                          onLongPressUp: () {
                            _passwordVisible.value = true;
                          },
                          child: Icon(
                            isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 22, 22, 180),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (_userTextFieldController.text.isEmpty ||
                        _passwordTextFieldController.text.isEmpty) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, ingrese los dos campos!'),
                          backgroundColor: Color.fromARGB(255, 206, 28, 28),
                        ),
                      );
                    } else {
                      bool loginSuccess = await userManager.login(
                        _userTextFieldController.text,
                        _passwordTextFieldController.text,
                      );
                      Trainer? usuario = userManager.getLoggedUser();
                      if (loginSuccess && usuario != null) {
                        context.goNamed(CalendarioScreen.name);
                        userManager.setLoggedUser(usuario);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Las credenciales no coinciden con ningun usuario registrado!'),
                            backgroundColor: Color.fromARGB(255, 206, 28, 28),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tenes una cuenta? ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(RegisterScreen.name);
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Color.fromARGB(255, 22, 22, 180),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
