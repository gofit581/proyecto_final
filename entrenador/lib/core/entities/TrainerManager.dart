import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/services/auth_service.dart';
import 'package:entrenador/services/register_service.dart';
import 'package:entrenador/services/update_service.dart';

class TrainerManager {
  static RegisterService registerService = RegisterService();
  static UpdateService updateService = UpdateService();
  static AuthService authService = AuthService(TrainerManager());
  static List<Trainer> _usuarios = [];
  static Trainer? _loggedUser;
  
  static List<Trainer> get usuarios => _usuarios;

  void agregarUsuario(Trainer usuario) {
    _usuarios.add(usuario);
  }

  Future<void> registerUser(Trainer trainer/*, int trainingId*/) async {
    //final Routine routine = await registerService.fetchRoutine(trainingId);
    //usuario.currentRoutine = routine;
    agregarUsuario(trainer);
    await registerService.registerUser(trainer/*, trainingId*/);
  }

  Trainer? existeUsuario(String mail, String password) {
    try {
      return _usuarios.firstWhere(
          (usuario) => usuario.mail == mail && usuario.password == password);
    } catch (e) {
      print('Error al buscar entrenador: $e');
      return null;
    }
  }

  void setLoggedUser(Trainer trainer) {
    _loggedUser = trainer;
  }

  Trainer? getLoggedUser() {
    return _loggedUser;
  }

  void logoutUser() {
    _loggedUser = null;
  }

  var login = (String mail, String password) async =>
      {authService.loginAndSetUser(mail, password)};

  Future<void> updateLoggedUser() async {
    if (_loggedUser != null) {
      await updateService.updateUser(_loggedUser!);
    } else {
      throw Exception('No user is currently logged in');
    }
  }

/*   Routine? getRoutine(){
    return _loggedUser!.getRoutine();
  }

  List<int> getRutineDays(){
    return List<int>.generate(_loggedUser!.currentRoutine!.duration, (i) => i + 1);
  }

  Set<DateTime> getExerciseDays(){
    return _loggedUser!.timesDone.toSet();
  }

  void ordenarLista(){
    _loggedUser!.timesDone.sort((a, b) => a.compareTo(b));
  }

    void resetExercises() {
     _loggedUser!.getRoutine()!.resetExercises();
    
  }

void clearUserListTimesDone(){
  _loggedUser!.clearTimesDone();
} */
  void updateUserInfo(String name, String email, String Age, String password/*, TypeOfTraining training*/){
      _loggedUser!.setUserName(name);
      _loggedUser!.setEmail(email);
      _loggedUser!.setAge(Age);
      //_loggedUser!.setTraining(training);
      //_loggedUser!.clearTimesDone();
      updateLoggedUser();
  }

}