// ignore_for_file: file_names

class Exercise {
  final String title;
  String? imageLink;
  String? description;
  int? series;
  int? repetitions;
  bool? done;
  late String? idTrainer; //checkear


  Exercise.prueba({
    required this.title,
    required this.series,
    required this.repetitions,
  });
  
   Exercise({
    required this.title,
    required this.imageLink,
    this.series,
    required this.description,
    this.done = false, 
    this.repetitions,
    this.idTrainer,
  });
  void toggleDone() {
    done = !done!;
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
