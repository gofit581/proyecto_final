import 'package:entrenador/services/users_getter_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_botton_navigation_bar.dart';
import '../core/entities/User.dart';

class StudentProfileScreen extends StatefulWidget {
  static const String name = 'ProfileScreen';
  final Usuario usuarioSeleccionado;

  const StudentProfileScreen({super.key, required this.usuarioSeleccionado});

  @override
  // ignore: library_private_types_in_public_api
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool isLoading = false;
  final UsersGetterService _usersGetterService = UsersGetterService();
  late Usuario usuarioActualizado;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    usuarioActualizado = widget.usuarioSeleccionado;
  }

  Future<void> _loadUserData() async {
    setState(() {
    });

    Usuario usuarioFromDB = await _usersGetterService.getUserById(widget.usuarioSeleccionado.id!);

    setState(() {
      isLoading = false;
      usuarioActualizado = usuarioFromDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Perfil del alumno',
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
                            usuarioActualizado.userName,
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
                           usuarioActualizado.getEmail(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Edad',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            usuarioActualizado.getAge(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Información del Alumno',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 22, 22, 180)),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow('Objetivo', usuarioActualizado.objectiveDescription),
                        _buildInfoRow('Experiencia', usuarioActualizado.experience),
                        _buildInfoRow('Disciplina', usuarioActualizado.discipline),
                        _buildInfoRow('Días de Entrenamiento', usuarioActualizado.trainingDays),
                        _buildInfoRow('Duración del Entrenamiento', usuarioActualizado.trainingDuration),
                        _buildInfoRow('Lesiones', usuarioActualizado.injuries),
                        _buildInfoRow('Actividades Extras', usuarioActualizado.extraActivities),
                        _buildInfoRow('Rutina Asignada', usuarioActualizado.currentRoutine?.getTitle() ?? 'Sin rutina asignada',),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                          // ignore: avoid_print
                          print(usuarioActualizado.currentRoutine);
                          if (usuarioActualizado.currentRoutine != null) {
                            context.push('/CompleteRoutine', extra: usuarioActualizado.currentRoutine);
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
                          'VER RUTINA',
                          style: TextStyle(color: Colors.white),
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
                          if (usuarioActualizado.currentRoutine == null) {
                            context.push('/AddRoutine', extra: usuarioActualizado);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Asignar Nueva Rutina'),
                                  content: const Text(
                                      'El alumno posee una rutina en proceso. ¿Desea asignarle una nueva rutina?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        // Cierra el diálogo sin hacer nada
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Asignar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        context.push('/AddRoutine', extra: usuarioActualizado);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          'ASIGNAR RUTINA',
                          style: TextStyle(color: Colors.white),
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
            value ?? 'Sin especificar',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
