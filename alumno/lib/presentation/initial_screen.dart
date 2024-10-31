import 'package:flutter/material.dart';
import 'dart:async';

import '../core/entities/UserManager.dart';

import 'welcome_screen.dart';
import 'calendar_screen.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialScreen extends StatefulWidget {
  static const String name = 'InitialScreen';

  const InitialScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final UserManager userManager = UserManager();

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null && await userManager.login(savedEmail, savedPassword)) {
      // ignore: use_build_context_synchronously
      context.goNamed(CalendarioScreen.name);
    }
    else{
      // ignore: use_build_context_synchronously
      context.goNamed(WelcomeScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
