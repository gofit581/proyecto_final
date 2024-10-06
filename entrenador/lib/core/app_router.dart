import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/presentation/create_routine2_screen.dart';
import 'package:entrenador/presentation/create_routine_screen.dart';
import 'package:entrenador/presentation/initial_screen.dart';
import 'package:entrenador/presentation/login_screen.dart';
import 'package:entrenador/presentation/register_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  
  GoRoute(
    path: '/initial',
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
  GoRoute(
    path: '/',
    builder: (context, state) => CreateRoutineScreen(
      /*actualUser: state.extra as Usuario*/),
    name: CreateRoutineScreen.name,
    ),
  GoRoute(
    path: '/createRoutine2',
    builder: (context, state) => CreateRoutine2Screen(
      datos: state.extra as Map<Routine, Usuario>,),
      //routine: state.extra['routine'] as Routine,
      //actualUser: state.extra as Usuario),
    name: CreateRoutine2Screen.name,
    ),
]);
