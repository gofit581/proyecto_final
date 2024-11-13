// ignore_for_file: file_names

import 'package:alumno/core/entities/User.dart';
import '../../services/auth_service.dart';
import '../../services/update_service.dart';
import '../../services/register_service.dart';

class UserManager {
  static RegisterService registerService = RegisterService();
  static UpdateService updateService = UpdateService();
  static AuthService authService = AuthService(UserManager());
  // ignore: prefer_final_fields
  static List<Usuario> _usuarios = [];
  static Usuario? _loggedUser;
  
  static List<Usuario> get usuarios => _usuarios;

  void agregarUsuario(Usuario usuario) {
    _usuarios.add(usuario);
  }

  Future<void> registerUser(Usuario usuario) async {
    agregarUsuario(usuario);
    await registerService.registerUser(usuario);
  }

  Usuario? existeUsuario(String mail, String password) {
    try {
      return _usuarios.firstWhere(
          (usuario) => usuario.mail == mail && usuario.password == password);
    } catch (e) {
      // ignore: avoid_print
      print('Error al buscar usuario: $e');
      return null;
    }
  }

  void setLoggedUser(Usuario user) {
    _loggedUser = user;
  }

  Usuario? getLoggedUser() {
    return _loggedUser;
  }

  void updateUser(Usuario usuarioViejo, Usuario usuarioActualizado){
    usuarioViejo.userName = usuarioActualizado.userName;
    usuarioViejo.password = usuarioActualizado.password;

    usuarioViejo.objectiveDescription = usuarioActualizado.objectiveDescription;
    usuarioViejo.experience = usuarioActualizado.experience;
    usuarioViejo.discipline = usuarioActualizado.discipline;
    usuarioViejo.trainingDays = usuarioActualizado.trainingDays;
    usuarioViejo.trainingDuration = usuarioActualizado.trainingDuration;
    usuarioViejo.injuries = usuarioActualizado.injuries;
    usuarioViejo.extraActivities = usuarioActualizado.extraActivities;
    //Agregar cosas si es necesario
  }

  Future<void> refreshUser (Usuario usuarioDesactualizado) async {
    authService.loginAndSetUser(usuarioDesactualizado.mail, usuarioDesactualizado.password);
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

  void updateUserInfo(String name, String email, String age, String password){
      _loggedUser!.setUserName(name);
      _loggedUser!.setEmail(email);
      _loggedUser!.setAge(age);
      updateLoggedUser();
  }
  var validateId = (String idTrainter) async {
    bool result = await authService.searchIdTrainer(idTrainter);
    return result;
  };
  var validateMail = (String mail) async {
    bool result = await authService.validateMail(mail);
    return result;
  };
}