import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/presentation/add_routine_screen.dart';
import 'package:entrenador/presentation/agenda_screen.dart';
import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/presentation/calendar_screen.dart';
import 'package:entrenador/presentation/comple_routine_screen.dart';
import 'package:entrenador/presentation/create_exercise_screen.dart';
import 'package:entrenador/presentation/create_routine2_screen.dart';
import 'package:entrenador/presentation/create_routine_screen.dart';
import 'package:entrenador/presentation/edit_routine_screen.dart';
import 'package:entrenador/presentation/initial_screen.dart';
import 'package:entrenador/presentation/list_routine.dart';
import 'package:entrenador/presentation/login_screen.dart';
import 'package:entrenador/presentation/notification_screen.dart';
import 'package:entrenador/presentation/register_entrenador_data_screen.dart';
import 'package:entrenador/presentation/register_screen.dart';
import '../presentation/profile_screen.dart';
import 'package:entrenador/presentation/users_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:entrenador/presentation/clases_dia_screen.dart';
import '../presentation/welcome_screen.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const InitialScreen(),
    name: InitialScreen.name,
  ),
  GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
      name: LoginScreen.name
  ),
  GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
      name: WelcomeScreen.name
  ),
  GoRoute(
      path: '/alumnos',
      builder: (context, state) => const UsersListScreen(),
      name: UsersListScreen.name),
  GoRoute(
    path: '/profile',
    builder: (context, state) {
      return MyProfileScreen();
    },
    name: MyProfileScreen.name,
  ),
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
      builder: ((context, state) => const AgendaScreen()),
      name: AgendaScreen.name),
  GoRoute(
    path: '/calendar',
    builder: (context, state) => CalendarioScreen(),
    name: CalendarioScreen.name,
  ),
  GoRoute(
      path: '/ListRoutine',
      builder: ((context, state) => const ListRoutine()),
      name: ListRoutine.name),
  GoRoute(
      path: '/AddRoutine',
      builder: ((context, state) =>
          AddRoutineScreen(alumno: state.extra as Usuario)),
      name: AddRoutineScreen.name),
  GoRoute(
      path: '/CompleteRoutine',
      builder: ((context, state) =>
          CompleteRoutineScreen(currentRoutine: state.extra as Routine,)),
      name: CompleteRoutineScreen.name),
  GoRoute(
    path: '/createRoutine',
    builder: (context, state) =>
        const CreateRoutineScreen(),
    name: CreateRoutineScreen.name,
  ),
  GoRoute(
    path: '/createRoutine2',
    builder: (context, state) => CreateRoutine2Screen(
      routine: state.extra as Routine,
    ),
    name: CreateRoutine2Screen.name,
  ),
  GoRoute(
    path: '/clasesDia',
    builder: (context, state) => ClasesDiaScreen(
      date: state.extra as DateTime,
    ),
    name: ClasesDiaScreen.name,
  ),
  GoRoute(
    path: '/createExercise',
    // path: '/',
    builder: (context, state) {
      final routine = state.extra as Routine;
      return CreateExerciseScreen(routine: routine);
    },
    name: CreateExerciseScreen.name,
  ),
  GoRoute(
    path: '/editRoutine',
    builder: (context, state) {
      final routine = state.extra as Routine;
      return EditRoutineScreen(routine: routine);
    },
    name: EditRoutineScreen.name,
  ),
  GoRoute(
    path: '/notifications',
    builder: (context, state) =>
       const NotificationScreen(),
    name: NotificationScreen.name,
  ),
]);
