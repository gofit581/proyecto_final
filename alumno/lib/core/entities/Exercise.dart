class Exercise {
  final String title;
  late String imageLink;
  late String description;
  late int series;
  late int repetitions;
  late bool done;
  
  Exercise.prueba({
    required this.title,
    required this.series,
    required this.repetitions,
  });
  
   Exercise({
    required this.title,
    required this.imageLink,
    required this.description,
    this.done = false
  });
  void toggleDone() {
    done = !done;
  }




}
