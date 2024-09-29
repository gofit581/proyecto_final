import 'package:alumno/core/entities/User.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/presentation/initial_screen.dart';
import 'package:alumno/presentation/login_screen.dart';
import 'package:alumno/presentation/register_alumno_data_screen.dart';
import 'package:alumno/presentation/register_screen.dart';
//import '../presentation/';
import 'package:go_router/go_router.dart';
import '../presentation/profile_screen.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const InitialScreen(),
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
  /*
    GoRoute(
    path: '/clases',
    builder: (context, state) => ClasesScreen(
      date: state.extra as DateTime,
    ),
    name: ClasesScreen.name,
  ),*/
   GoRoute(
     path: '/profile',
      builder: (context, state) {
       return const MyProfileScreen();
     },
     name: MyProfileScreen.name,
    ),
  GoRoute(
    path: '/registerAlumnoData',
    builder: (context, state) => RegisterAlumnoDataScreen(
      usuario: state.extra as Usuario,
    ),
    name: RegisterAlumnoDataScreen.name,
  ),
  GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
      name: RegisterScreen.name),
  GoRoute(
      path: '/calendar',
      builder: ((context, state) => const CalendarioScreen()),
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
