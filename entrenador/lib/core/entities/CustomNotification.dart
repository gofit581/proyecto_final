import 'package:entrenador/core/entities/TypeOfNotification.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/services/users_getter_service.dart';

class CustomNotification {
  String id;
  String idAlumno;
  String idTrainer;
  TypeOfNotification typeOfNotification;
  bool visto;

  CustomNotification({
    required this.idAlumno,
    required this.idTrainer,
    required this.typeOfNotification,
    required this.visto,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'idAlumno': idAlumno,
      'idTrainer': idTrainer,
      'typeOfNotification': typeOfNotification.toString().split('.').last,
      'visto': visto,
      'id': id,
    };
  }

  factory CustomNotification.fromJson(Map<String, dynamic> json) {
    return CustomNotification(
      idAlumno: json['idAlumno'],
      idTrainer: json['idTrainer'],
      typeOfNotification: TypeOfNotification.values.firstWhere(
        (e) => e.toString().split('.').last == json['typeOfNotification'],
      ),
      visto: json['visto'],
      id: json['id'],
    );
  }

  String getMessage()
  {
    switch (typeOfNotification) {
      case TypeOfNotification.finishedRoutine:
        return ' ha finalizado su rutina';
      case TypeOfNotification.newUser:
        return ' ha comenzado a entrenar con vos';
      case TypeOfNotification.reservation:
        return ' ha reservado una clase';
      default:
        return 'Notificación';
    }
  }

  Future<Usuario> getAlumno()
  {
    return UsersGetterService().getUserById(idAlumno);
  }
}
