import 'package:alumno/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/core/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}