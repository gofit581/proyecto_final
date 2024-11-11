import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/presentation/trainingDay_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/profile_screen.dart';
import '../presentation/calendar_screen.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;


const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {

Usuario usuario = UserManager().getLoggedUser()!;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/image/ROUTINE.jpg',
            width: 40, height: 40,
          ),
          label: 'Rutina'
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/image/HOME.jpg',
            width: 40, height: 40,
          ),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/image/PROFILE.jpg',
            width: 40, height: 40,
          ),
          label: 'Mi Perfil',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if(usuario.actualRoutine == null){
              _rutinaVacia(context, usuario.userName);
            } else{
              context.goNamed(TrainingdayScreen.name);
            }
            break;
          case 1:
            context.goNamed(CalendarioScreen.name);
            break;
          case 2:
            context.goNamed(MyProfileScreen.name);
            break;
          default:
            break;
        }
      },
    );
  }
}

void _rutinaVacia(BuildContext context, String userName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ATENCIÓN $userName'),
        content: const Text('Aun no posees una rutina, comunicate con tu entrenador para poder comenzar tu entrenamiento!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}