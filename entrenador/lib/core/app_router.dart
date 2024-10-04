import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/presentation/agenda_screen.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/presentation/initial_screen.dart';
import 'package:entrenador/presentation/login_screen.dart';
import 'package:entrenador/presentation/register_entrenador_data_screen.dart';
import 'package:entrenador/presentation/register_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => InitialScreen(),
    name: InitialScreen.name,
  ),
  GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
      name: LoginScreen.name),
  // GoRoute(
  //   path: '/home',
  //   builder: (context, state) {
  //     return HomeScreen();
  //   },
  //   name: HomeScreen.name,
  // ),
  // GoRoute(
  //   path: '/profile',
  //   builder: (context, state) {
  //     return ProfileScreen();
  //   },
  //   name: ProfileScreen.name,
  // ),
  GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
      name: RegisterScreen.name),
  GoRoute(
      path: '/registerEntrenadorDataScreen',
      builder: (context, state) => RegisterEntrenadorDataScreen(
        trainer: state.extra as Trainer,
      ),
      name: RegisterEntrenadorDataScreen.name),
  GoRoute(
      path: '/agenda',
      builder: ((context, state) => AgendaScreen()),
      name: AgendaScreen.name),
  GoRoute(
      path: '/calendar',
      builder: ((context, state) => CalendarioScreen()),
      name: CalendarioScreen.name),
  // GoRoute(
  //     path: '/routine',
  //     builder: (context, state) => RoutineScreen(),
  //     name: RoutineScreen.name),
  // GoRoute(
  //     path: '/routines',
  //     builder: (context, state) => RoutinesScreen(),
  //     name: RoutinesScreen.name),
  // GoRoute(
  //     path: '/profile-info',
  //     builder: (context, state) => ProfileInfoScreen(),
  //     name: ProfileInfoScreen.name)
]);
