import 'package:alumno/core/entities/User.dart';
import '../../services/auth_service.dart';
import '../../services/update_service.dart';
import '../../services/register_service.dart';

class UserManager {
  static RegisterService registerService = RegisterService();
  static UpdateService updateService = UpdateService();
  static AuthService authService = AuthService(UserManager());
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