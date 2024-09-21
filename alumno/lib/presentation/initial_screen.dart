import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alumno/presentation/login_screen.dart';
import 'package:alumno/presentation/register_screen.dart';

class InitialScreen extends StatelessWidget {
  static const String name = 'InitialScreen';

  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Center(
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 193, 193, 196),
                  elevation: 5,
                  fixedSize: Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  context.goNamed(LoginScreen.name);
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 22, 22, 180),
                  elevation: 5,
                  fixedSize: Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  context.goNamed(RegisterScreen.name);
                },
                child: const Text(
                  'REGISTRARSE',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}