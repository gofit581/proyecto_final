import 'package:alumno/core/entities/Routine.dart';
import 'package:alumno/core/entities/User.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/presentation/complete_routine_screen.dart';
import 'package:alumno/presentation/initial_screen.dart';
import 'package:alumno/presentation/login_screen.dart';
import 'package:alumno/presentation/register_alumno_data_screen.dart';
import 'package:alumno/presentation/register_screen.dart';
import 'package:alumno/presentation/clases_screen.dart';
import 'package:alumno/presentation/trainingDay_screen.dart';
import 'package:go_router/go_router.dart';
import '../presentation/profile_screen.dart';
import '../presentation/welcome_screen.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const InitialScreen(),
    name: InitialScreen.name,
  ),
  GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
      name: LoginScreen.name
      ),
  GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
      name: WelcomeScreen.name
      ),
   GoRoute(
     path: '/profile',
      builder: (context, state) {
       return MyProfileScreen();
     },
     name: MyProfileScreen.name,
    ),
  GoRoute(
    path: '/registerAlumnoData',
    builder: (context, state) => RegisterAlumnoDataScreen(
      user: state.extra as Usuario,
    ),
    name: RegisterAlumnoDataScreen.name,
  ),
  GoRoute(
    path: '/clases',
    builder: (context, state) => ClasesScreen(
      date: state.extra as DateTime,
    ),
    name: ClasesScreen.name,
  ),
  GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
      name: RegisterScreen.name),
  GoRoute(
      path: '/calendar',
      builder: ((context, state) => const CalendarioScreen()),
      name: CalendarioScreen.name),
  GoRoute(
      path: '/trainingDay',
      builder: ((context, state) =>  TrainingdayScreen()),
      name: TrainingdayScreen.name),
  GoRoute(
      path: '/CompleteRoutine',
      builder: ((context, state) =>  CompleteRoutineScreen(currentRoutine: state.extra as Routine,)),
      name: CompleteRoutineScreen.name),  
]);
