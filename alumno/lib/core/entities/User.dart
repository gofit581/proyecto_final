import '../entities/Entrenador.dart';

class Usuario {
  final String? id;
  String userName;
  String password;
  String mail;
  String age;
  String idTrainer;
  String? objectiveDescription;
  String? experience;
  String? discipline;
  String? trainingDays;
  String? trainingDuration;
  String? injuries;
  String? extraActivities;
  Entrenador? profesor;

  Usuario.parcial({
    this.id,
    required this.userName,
    required this.password,
    required this.mail,
    required this.age,
    required this.idTrainer,
  });

  Usuario({
    this.id,
    required this.userName,
    required this.password,
    required this.mail,
    required this.age,
    required this.idTrainer,
    required this.objectiveDescription,
    required this.experience,
    required this.discipline,
    required this.trainingDays,
    required this.trainingDuration,
    required this.injuries,
    required this.extraActivities,
  });

   factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      userName: json['userName'],
      password: json['password'],
      mail: json['mail'],
      age: json['age'],
      idTrainer: json['idTrainer'],
      objectiveDescription: json['objectiveDescription'],
      experience: json['experience'],
      discipline: json['discipline'],
      trainingDays: json['trainingDays'],
      trainingDuration: json['trainingDuration'],
      injuries: json['injuries'],
      extraActivities: json['extraActivities'],
    );
  }

  @override
  String toString() {
    return userName;
  }

  String getEmail() {
    return mail;
  }

  String getAge() {
    return age;
  }

  Entrenador? getProfesor() {
    return profesor;
  }

  Usuario.isEmpty() : 
      id='',
      userName='',
      password='',
      mail='',
      age='',
      idTrainer='',
      objectiveDescription='',
      experience='',
      discipline='',
      trainingDays='',
      trainingDuration='',
      injuries='',
      extraActivities='';

  void setUserName(String name) {
    userName = name;
  }

  void setProfesor(Entrenador profesor) {
    profesor = profesor;
  }

  void setAge(String edad) {
    age = edad;
  }

  void setEmail(String email) {
    mail = email;
  }
}
