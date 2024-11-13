import 'package:alumno/core/entities/Exercise.dart';
import 'package:alumno/core/entities/Routine.dart';
import 'package:alumno/core/entities/User.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/presentation/comple_routine_screen.dart';
import 'package:alumno/presentation/exercise_detail_screen.dart';
import 'package:alumno/presentation/initial_screen.dart';
import 'package:alumno/presentation/login_screen.dart';
import 'package:alumno/presentation/register_alumno_data_screen.dart';
import 'package:alumno/presentation/register_screen.dart';
import 'package:alumno/presentation/clases_screen.dart';
import 'package:alumno/presentation/trainingDay_screen.dart';
import 'package:flutter/material.dart';
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
     pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: MyProfileScreen(),
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
    path: '/registerAlumnoData',
    builder: (context, state) => RegisterAlumnoDataScreen(
      usuario: state.extra as Usuario,
    ),
    name: RegisterAlumnoDataScreen.name,
    pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: RegisterAlumnoDataScreen(usuario: state.extra as Usuario),
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
      name: CalendarioScreen.name,
      pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const CalendarioScreen(),
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
      path: '/trainingDay',
      builder: ((context, state) =>  TrainingdayScreen()),
      name: TrainingdayScreen.name,
      pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const TrainingdayScreen(),
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
      path: '/CompleteRoutine',
      builder: ((context, state) =>  CompleteRoutineScreen(currentRoutine: state.extra as Routine,)),
      name: CompleteRoutineScreen.name), 
  GoRoute(
      path: '/ExerciseDetail',
      builder: ((context, state) =>  ExerciseDetailScreen(exercise: state.extra as Exercise,)),
      name: ExerciseDetailScreen.name),   
]);
