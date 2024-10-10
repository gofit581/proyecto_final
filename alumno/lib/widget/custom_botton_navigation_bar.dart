import 'package:flutter/material.dart';
import '../presentation/profile_screen.dart';
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
            context.goNamed('ProfileScreen');
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
  final List<Widget> _children = [
    const Center(child: Text('Pantalla Rutina')),
    const Center(child: Text('Pantalla Principal')),
    MyProfileScreen(),

  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex
      ),
    );
  }
}