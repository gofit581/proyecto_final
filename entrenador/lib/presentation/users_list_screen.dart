import 'package:entrenador/presentation/student_profile_screen.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:entrenador/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/services/users_getter_service.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';

class UsersListScreen extends StatefulWidget {
  static const String name = 'UsersListScreen';
  const UsersListScreen({super.key});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late Future<List<Usuario>> _clientsFuture;
  final UsersGetterService _usersGetterService = UsersGetterService();
  Trainer? _loggedTrainer;

  @override
  void initState() {
    super.initState();
    _loggedTrainer = TrainerManager().getLoggedUser();
    if (_loggedTrainer != null) {
      _clientsFuture = _usersGetterService.getUsersByTrainerId(_loggedTrainer!.trainerCode!);
    } else {
      // Manejar el caso en que el entrenador logueado es null
      _clientsFuture = Future.error('No trainer logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mis Alumnos'
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: FutureBuilder<List<Usuario>>(
        future: _clientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No clients found'));
          } else {
            final clients = snapshot.data!;
            return ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(client.userName),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentProfileScreen(usuarioSeleccionado: client),
                        ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}