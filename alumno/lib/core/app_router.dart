import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/presentation/initial_screen.dart';
import 'package:alumno/presentation/login_screen.dart';
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
  // GoRoute(
  //     path: '/register',
  //     builder: (context, state) => RegisterScreen(),
  //     name: RegisterScreen.name),
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
