import 'package:entrenador/core/entities/TypeOfNotification.dart';

class Notification {
  String idAlumno;
  String idTrainer;
  //String? mensaje;
  TypeOfNotification typeOfNotification;

  Notification({
    required this.idAlumno,
    required this.idTrainer,
    required this.typeOfNotification,
    //this.mensaje
  });

  Map<String, dynamic> toJson() {
    return {
      'idAlumno': idAlumno,
      'idTrainer': idTrainer,
      //'mensaje': mensaje,
      'typeOfNotification': typeOfNotification.toString().split('.').last,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      idAlumno: json['idAlumno'],
      idTrainer: json['idTrainer'],
      //mensaje: json['mensaje'],
      typeOfNotification: TypeOfNotification.values.firstWhere(
        (e) => e.toString().split('.').last == json['typeOfNotification'],
      ),
    );
  }
}
