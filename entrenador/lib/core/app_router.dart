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
import 'package:entrenador/presentation/student_profile_screen.dart';
import 'package:flutter/material.dart';
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
      name: UsersListScreen.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const UsersListScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); 
            const end = Offset.zero;         
            const curve = Curves.easeInOut;  
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },    
    ),  

  GoRoute(
    path: '/profile',
    builder: (context, state) {
      return MyProfileScreen();
    },
    name: MyProfileScreen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: MyProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0); 
          const end = Offset.zero;         
          const curve = Curves.easeInOut;  
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    },   
  ),

  GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
      name: RegisterScreen.name
  ),

  GoRoute(
    path: '/registerEntrenadorDataScreen',
    builder: (context, state) => RegisterEntrenadorDataScreen(
          trainer: state.extra as Trainer,
          ),
    name: RegisterEntrenadorDataScreen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: RegisterEntrenadorDataScreen(trainer: state.extra as Trainer),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); 
          const end = Offset.zero;         
          const curve = Curves.easeInOut;  
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    },     
  ),

  GoRoute(
    path: '/agenda',
    builder: ((context, state) => const AgendaScreen()),
    name: AgendaScreen.name,
  ),

  GoRoute(
    path: '/calendar',
    builder: (context, state) => CalendarioScreen(),
    name: CalendarioScreen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: CalendarioScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);  
          const end = Offset.zero;           
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    },   
  ),

  GoRoute(
    path: '/ListRoutine',
    builder: ((context, state) => const ListRoutine()),
    name: ListRoutine.name,
    pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const ListRoutine(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); 
            const end = Offset.zero;         
            const curve = Curves.easeInOut;  

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },    
    ),

  GoRoute(
      path: '/AddRoutine',
      builder: ((context, state) =>
          AddRoutineScreen(alumno: state.extra as Usuario)),
      name: AddRoutineScreen.name
  ),

  GoRoute(
      path: '/CompleteRoutine',
      builder: ((context, state) =>
          CompleteRoutineScreen(currentRoutine: state.extra as Routine,)),
      name: CompleteRoutineScreen.name
  ),

  GoRoute(
    path: '/createRoutine',
    builder: (context, state) => const CreateRoutineScreen(),
    name: CreateRoutineScreen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: const CreateRoutineScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);  
          const end = Offset.zero;           
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    },  
  ),

  GoRoute(
    path: '/createRoutine2',
    builder: (context, state) => CreateRoutine2Screen(
      routine: state.extra as Routine,
    ),
    name: CreateRoutine2Screen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: CreateRoutine2Screen(routine: state.extra as Routine,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); 
          const end = Offset.zero;         
          const curve = Curves.easeInOut;  
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    }, 
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
    builder: (context, state) {
      final routine = state.extra as Routine;
      return CreateExerciseScreen(routine: routine);
    },
    name: CreateExerciseScreen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: CreateExerciseScreen(routine: state.extra as Routine),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); 
          const end = Offset.zero;         
          const curve = Curves.easeInOut;  
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    },  
  ),

  GoRoute(
    path: '/editRoutine',
    builder: (context, state) {
      final routine = state.extra as Routine;
      return EditRoutineScreen(routine: routine);
    },
    name: EditRoutineScreen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: EditRoutineScreen(routine: state.extra as Routine,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); 
          const end = Offset.zero;         
          const curve = Curves.easeInOut;  
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    }, 
  ),

  GoRoute(
    path: '/studentProfileScreen',
    builder: (context, state) => StudentProfileScreen(
      usuarioSeleccionado: state.extra as Usuario,
    ),
    name: StudentProfileScreen.name,
    pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: StudentProfileScreen(usuarioSeleccionado: state.extra as Usuario),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); 
            const end = Offset.zero;         
            const curve = Curves.easeInOut;  

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },   
    ),
  
  GoRoute(
    path: '/notifications',
    builder: (context, state) => const NotificationScreen(),
    name: NotificationScreen.name,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: const NotificationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0); 
          const end = Offset.zero;           
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    },
  ),
  
]);
