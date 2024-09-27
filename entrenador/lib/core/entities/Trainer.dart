class Trainer {
  final String? id;
  String userName;
  String age;
  String mail;
  String password;
  String trainerCode;
  //List<User> clients;

Trainer(
     {
     this.id,
      required this.userName,
      required this.password,
      required this.mail,
      required this.age,
      required this.trainerCode,
});

@override
String toString() {
  return userName;
}


String getEmail(){
  return mail;
}

String getAge(){
  return age;
}

void setUserName(String name){
  userName = name;
}

void setAge(String edad){
  age = edad;
}

void setEmail(String email){
  mail = email;
}

}
