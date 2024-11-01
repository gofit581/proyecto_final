import 'package:alumno/core/entities/Entrenador.dart';
import 'package:alumno/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_botton_navigation_bar.dart';
import '../presentation/initial_screen.dart';
import '../core/entities/UserManager.dart';
import '../core/entities/User.dart';
import '../core/entities/Entrenador.dart';


class MyProfileScreen extends StatefulWidget {
  static const String name = 'ProfileScreen';
  UserManager userManager = UserManager();

  MyProfileScreen({super.key});

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
        entrenadorAsignado = actualUsuario!.getProfesor();
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
                // Navegar a la pantalla initial_screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InitialScreen()),
                );
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
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
      appBar: const CustomAppBar(
        title: 'Profile',
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
                          child:  Text(
                            entrenadorAsignado!.getNombre(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),                  
                  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 22, 22, 180),
                          elevation: 5,
                          fixedSize: const Size(170, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        
                        onPressed: () {
                          if (actualUsuario?.actualRoutine != null) {
                            context.push('/CompleteRoutine', extra: actualUsuario?.actualRoutine);
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('El usuario no tiene una rutina asignada'),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Ver Rutina',
                          style: TextStyle(color: Colors.white),
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
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
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
}
