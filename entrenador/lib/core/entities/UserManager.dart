// import 'package:entrenador/core/entities/Routine.dart';
// import 'package:entrenador/core/entities/TypeOfTraining.dart';
// import 'package:entrenador/core/entities/User.dart';
// import '../../../services/auth_service.dart';
// import '../../../services/update_service.dart';
// import '../../../services/register_service.dart';

// class UserManager {
//   static RegisterService registerService = RegisterService();
//   static UpdateService updateService = UpdateService();
//   static AuthService authService = AuthService(UserManager());
//   static List<Usuario> _usuarios = [];
//   static Usuario? _loggedUser;
  
//   static List<Usuario> get usuarios => _usuarios;

//   void agregarUsuario(Usuario usuario) {
//     _usuarios.add(usuario);
//   }

//   Future<void> registerUser(Usuario usuario, int trainingId) async {
//     final Routine routine = await registerService.fetchRoutine(trainingId);
//     usuario.currentRoutine = routine;
//     agregarUsuario(usuario);
//     await registerService.registerUser(usuario, trainingId);
//   }

//   Usuario? existeUsuario(String mail, String password) {
//     try {
//       return _usuarios.firstWhere(
//           (usuario) => usuario.mail == mail && usuario.password == password);
//     } catch (e) {
//       print('Error al buscar usuario: $e');
//       return null;
//     }
//   }

//   void setLoggedUser(Usuario user) {
//     _loggedUser = user;
//   }

//   Usuario? getLoggedUser() {
//     return _loggedUser;
//   }

//   void logoutUser() {
//     _loggedUser = null;
//   }

//   var login = (String mail, String password) async =>
//       {authService.loginAndSetUser(mail, password)};

//   Future<void> updateLoggedUser() async {
//     if (_loggedUser != null) {
//       await updateService.updateUser(_loggedUser!);
//     } else {
//       throw Exception('No user is currently logged in');
//     }
//   }

//   Routine? getRoutine(){
//     return _loggedUser!.getRoutine();
//   }

//   List<int> getRutineDays(){
//     return List<int>.generate(_loggedUser!.currentRoutine!.duration, (i) => i + 1);
//   }

//   Set<DateTime> getExerciseDays(){
//     return _loggedUser!.timesDone.toSet();
//   }

//   void ordenarLista(){
//     _loggedUser!.timesDone.sort((a, b) => a.compareTo(b));
//   }

//     void resetExercises() {
//      _loggedUser!.getRoutine()!.resetExercises();
    
//   }

// void clearUserListTimesDone(){
//   _loggedUser!.clearTimesDone();
// }
//   void updateUserInfo(String name, String email, int Age, String password, TypeOfTraining training){
//       _loggedUser!.setUserName(name);
//       _loggedUser!.setEmail(email);
//       _loggedUser!.setAge(Age);
//       _loggedUser!.setTraining(training);
//       _loggedUser!.clearTimesDone();
//       updateLoggedUser();
//   }

// }