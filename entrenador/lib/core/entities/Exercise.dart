class Exercise {
  String? title;
  String? imageLink;
  String? description;
  int? series;
  int? repetitions;
  bool? done;
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
    done = !done!;
  }

  void setTitle(String title){
    this.title = title;
  }

void aumentarSerie(){
  series = (series ?? 0) + 1;
}

void restarSerie(){
  series = (series ?? 0) - 1;
}

void aumentarRepeticiones(){
  repetitions = (repetitions ?? 0) + 1;
}

void restarRepeticiones(){
  repetitions = (repetitions ?? 0) - 1;
}

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageLink': imageLink,
      'description': description,
      'series': series,
      'repetitions': repetitions,
    };
  }

}
