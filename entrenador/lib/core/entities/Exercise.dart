class Exercise {
  String? title;
  String? imageLink;
  //Falta atributo para el video
  String? description;
  int? series;
  int? repetitions;
  bool? done;

  Exercise.vacio();

  Exercise.create(
    this.title,
    this.series,
    this.repetitions,
  );

   Exercise({
    required this.title,
    required this.imageLink,
    this.series,
    required this.description,
    this.done = false, 
    this.repetitions,
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

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      title: json['title'],
      imageLink: json['imageLink'],
      description: json['description'],
      series: json['series'],
      repetitions: json['repetitions'],
    );
  }

}