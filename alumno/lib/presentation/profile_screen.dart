import 'package:flutter/material.dart';

import '../core/entities/Entrenador.dart';
import '../core/entities/User.dart';
import '../core/entities/UserManager.dart';

import '../widget/custom_app_bar.dart';
import '../widget/custom_botton_navigation_bar.dart';

import '../presentation/initial_screen.dart';
import '../presentation/edit_profile.dart';

import '../services/auth_service.dart';

class MyProfileScreen extends StatefulWidget {
  static const String name = 'ProfileScreen';
  UserManager userManager = UserManager();

  MyProfileScreen({super.key});
  
  get actualUsuario => null;

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  
  Usuario? actualUsuario;
  Entrenador? entrenadorAsignado;
  bool isLoading = false;

  @override
void initState() {
  super.initState();
  _loadUserData();
}

Future<void> _loadUserData() async {
  setState(() {
    actualUsuario = UserManager().getLoggedUser();
    if (actualUsuario != null) {
      entrenadorAsignado = actualUsuario?.getProfesor() ?? Entrenador();
    }
  });
}

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Seguro que desea cerrar la sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InitialScreen()),
                );
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    usuario: actualUsuario!,
                    authService: AuthService(UserManager()),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/BANNER.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width / 2) - 50,
                        bottom: 0,
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/image/USER-PHOTO.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nombre Completo',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            actualUsuario.toString(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            actualUsuario!.getEmail(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Profesor Asignado',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            entrenadorAsignado!.getNombre(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Tus Datos',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 10),
                        //_buildInfoRow('Objetivo', actualUsuario?.objectiveDescription), //No se bien por que siempre me devuelve nulo en el metodo '_buildInfoRow' y muestra el texto 'No especificado'
                        _buildInfoRow('Experiencia', actualUsuario?.experience),
                        _buildInfoRow('Objetivo', actualUsuario?.objectiveDescription),
                        _buildInfoRow('Disciplina', actualUsuario?.discipline),
                        _buildInfoRow('Días de Entrenamiento', actualUsuario?.trainingDays),
                        _buildInfoRow('Duración del Entrenamiento', actualUsuario?.trainingDuration),
                        _buildInfoRow('Lesiones', actualUsuario?.injuries),
                        _buildInfoRow('Actividades Extras', actualUsuario?.extraActivities),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                          elevation: 5,
                          fixedSize: const Size(170, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          _showLogoutConfirmationDialog(context);
                        },
                        child: const Text(
                          'CERRAR SESION',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value ?? 'No especificado',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
