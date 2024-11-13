import 'package:entrenador/presentation/provider/counter_day_routine.dart';
import 'package:entrenador/presentation/provider/current_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/profile_screen.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final int currentIndex;

const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onTap: (index) async {
        bool changeValue = ref.watch(changesProvider);
        if(changeValue){
          bool discardChanges = await _showDiscardChangesDialog(context, ref);
          if (discardChanges) {
            switch (index) {
              case 0:
                // ignore: use_build_context_synchronously
                context.goNamed('ListRoutine');
                break;
              case 1:
                // ignore: use_build_context_synchronously
                context.goNamed('UsersListScreen');
                break;
              case 2:
                // ignore: use_build_context_synchronously
                context.goNamed('CalendarioScreen');
                break;
              case 3:
                // ignore: use_build_context_synchronously
                context.goNamed('ProfileScreen');
                break;
              default:
                break;
            }
          }
        }
        switch (index) {
          case 0:
            // ignore: use_build_context_synchronously
            context.goNamed('ListRoutine');
            break;
          case 1:
            // ignore: use_build_context_synchronously
            context.goNamed('UsersListScreen');
            break;
          case 2:
            // ignore: use_build_context_synchronously
            context.goNamed('CalendarioScreen');
            break;
          case 3:
            // ignore: use_build_context_synchronously
            context.goNamed('ProfileScreen');
            break;
          default:
            break;
        }
      },
    );
  }
    Future<bool> _showDiscardChangesDialog(BuildContext context, WidgetRef ref) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Descartar cambios'),
          content: const Text('¿Estás seguro de que deseas salir y descartar los cambios?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                ref.read(changesProvider.notifier).state = false;
                ref.read(counterDayProvider.notifier).state = 1;
                ref.read(counterWeekProvider.notifier).state = 1;
                Navigator.of(context).pop(true);
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    ) ?? false;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  final List<Widget> _children = [
    const Center(child: Text('Pantalla Rutina')),
    const Center(child: Text('Pantalla Lista Alumnos')),
    const Center(child: Text('Pantalla Principal')),
    MyProfileScreen(),

  ];


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