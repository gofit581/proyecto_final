class Exercise {
  late String title;
  String? imageLink;
  String? description;
  late int series;
  late int repetitions;
  late bool done;
  //int idDia;

  Exercise.vacio();

  Exercise.create(
    this.title,
    this.series,
    this.repetitions,
  );

   Exercise({
    required this.title,
    required this.imageLink,
    required this.description,
    this.done = false
  });
  
  void toggleDone() {
    done = !done;
  }

  void setTitle(String title){
    this.title = title;
  }

void aumentarSerie(){
  this.series++;
}

void restarSerie(){
  this.series--;
}

void aumentarRepeticiones(){
  this.repetitions++;
}

void restarRepeticiones(){
  this.repetitions--;
}


}
