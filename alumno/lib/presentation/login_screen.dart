// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/presentation/register_screen.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/core/entities/User.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userTextFieldController = TextEditingController();
  final TextEditingController _passwordTextFieldController = TextEditingController();
  final UserManager userManager = UserManager();
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _keepLoggedIn = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 92, 92, 92),
                    label: Text('Email'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _passwordVisible,
                  builder: (context, isObscured, child) {
                    return TextField(
                      controller: _passwordTextFieldController,
                      obscureText: isObscured,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 92, 92, 92),
                        label: const Text('Contraseña'),
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
              const SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: _keepLoggedIn,
                builder: (context, keepLoggedIn, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: keepLoggedIn,
                        onChanged: (value) {
                          _keepLoggedIn.value = value ?? false;
                        },
                      ),
                      const Text('Mantener la sesión iniciada'),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 22, 180),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (_userTextFieldController.text.isEmpty ||
                        _passwordTextFieldController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingrese los dos campos!'),
                          backgroundColor: Color.fromARGB(255, 206, 28, 28),
                        ),
                      );
                    } else {
                      bool loginSuccess = await userManager.login(
                        _userTextFieldController.text,
                        _passwordTextFieldController.text,
                      );
                      Usuario? usuario = userManager.getLoggedUser();
                      if (loginSuccess && usuario != null) {
                        if (_keepLoggedIn.value) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('email',
                              _userTextFieldController.text);
                          await prefs.setString('password',
                              _passwordTextFieldController.text);
                        }
                        context.goNamed(CalendarioScreen.name);
                        userManager.setLoggedUser(usuario);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
