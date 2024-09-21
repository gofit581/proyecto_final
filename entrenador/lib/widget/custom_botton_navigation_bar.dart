import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;


const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/image/ROUTINE.jpg',
            width: 40, height: 40,
          ),
          label: 'Routine'
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/image/MOBILE_FRIENDLY.jpg',
            width: 40, height: 40,
          ),
          label: 'Students',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/image/HOME.jpg',
            width: 40, height: 40,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/image/PROFILE.jpg',
            width: 40, height: 40,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.goNamed('RutinaScreen');
            break;
          case 1:
            context.goNamed('CalendarioScreen');
            break;
          case 2:
            context.goNamed('PerfilScreen');
            break;
          default:
            break;
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de pantallas que quieres mostrar al cambiar de tab
  final List<Widget> _children = [
    const Center(child: Text('Pantalla Rutina')),
    const Center(child: Text('Pantalla Estudiantes')),
    const Center(child: Text('Pantalla Principal')),
    const Center(child: Text('Pantalla Perfil')),

  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Bottom Navigation'),
      ),
      body: _children[_currentIndex], // Mostrar la pantalla correspondiente
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex
      ), // Usar el widget de navegación personalizado
    );
  }
}