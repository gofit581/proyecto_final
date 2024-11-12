import 'package:entrenador/core/entities/Clase.dart';
import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/services/auth_service.dart';
import 'package:entrenador/services/register_service.dart';
import 'package:entrenador/services/update_service.dart';
import 'package:entrenador/services/agenda_service.dart';

class TrainerManager {
  static RegisterService registerService = RegisterService();
  static UpdateService updateService = UpdateService();
  static AuthService authService = AuthService(TrainerManager());
  static List<Trainer> _usuarios = [];
  static Trainer? _loggedUser;
  static AgendaService agendaService = AgendaService();
  static List<Trainer> get usuarios => _usuarios;

  void agregarUsuario(Trainer usuario) {
    _usuarios.add(usuario);
  }

  Future<void> registerUser(Trainer trainer) async {
    agregarUsuario(trainer);
    await registerService.registerUser(trainer);
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

  void generarAgenda(DateTime desde, DateTime hasta) {
    agendaService.generarAgenda(desde, hasta);
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

  var login = (String mail, String password) async {
    bool success = await authService.loginAndSetUser(mail, password);
    return success;
  };

  Future<void> updateLoggedUser() async {
    if (_loggedUser != null) {
      await updateService.updateUser(_loggedUser!);
    } else {
      throw Exception('No user is currently logged in');
    }
  }

  void updateUserInfo(String name, String email, String Age,
      String password) {
    _loggedUser!.setUserName(name);
    _loggedUser!.setEmail(email);
    _loggedUser!.setAge(Age);
    updateLoggedUser();
  }

  var validateId = (String idTrainer) async {
    bool success = await authService.searchIdTrainer(idTrainer);
    return success;
  };

  var validateMail = (String mail) async {
    bool result = await authService.validateMail(mail);
    return result;
  };

  void borrarClaseId(Clase clase){
    agendaService.borrarClaseId(clase);
  }
}
