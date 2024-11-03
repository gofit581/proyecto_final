import 'package:alumno/core/entities/TypeOfNotification.dart';

class CustomNotification {
  String? id;
  String idAlumno;
  String idTrainer;
  TypeOfNotification typeOfNotification;
  bool visto;

  CustomNotification({
    required this.idAlumno,
    required this.idTrainer,
    required this.typeOfNotification,
    required this.visto,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'idAlumno': idAlumno,
      'idTrainer': idTrainer,
      'typeOfNotification': typeOfNotification.toString().split('.').last,
      'visto': visto,
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
}
