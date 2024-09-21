class Exercise {
  final String title;
  final String imageLink;
  final String description;
  bool done;
  
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
