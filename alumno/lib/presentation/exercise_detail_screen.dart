import 'package:alumno/core/entities/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exercise});

  static const String name = 'ExerciseDetail';
  final Exercise exercise;

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    print(widget.exercise.imageLink);
    if (widget.exercise.imageLink != null) {
      //podria ser que no le llega bien el parametro por eso no lo convierte
      final videoId = YoutubePlayer.convertUrlToId(widget.exercise.imageLink!);
      print(videoId);
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      _youtubeController = null;
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        widget.exercise.title,
      ),
      backgroundColor: Colors.white,
    ),
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 10,
                  shadowColor: const Color.fromARGB(255, 22, 22, 180).withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detalles del ejercicio',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 22, 22, 180),
                          ),
                        ),
                        const Divider(color: Color.fromARGB(255, 22, 22, 180), thickness: 1.2),
                        const SizedBox(height: 15),
                        detailItem('Series', '${widget.exercise.series}'),
                        const SizedBox(height: 10),
                        detailItem('Repeticiones', '${widget.exercise.repetitions}'),
                        const SizedBox(height: 10),
                        detailItem('Descripción', widget.exercise.description!),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 10,
                  shadowColor:const Color.fromARGB(255, 22, 22, 180).withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Explicación del ejercicio',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 22, 22, 180),
                          ),
                        ),
                        const Divider(color: Color.fromARGB(255, 22, 22, 180), thickness: 1.2),
                        const SizedBox(height: 15),
                        if (_youtubeController != null)
                          YoutubePlayerBuilder(
                            player: YoutubePlayer(
                              controller: _youtubeController!,
                              showVideoProgressIndicator: true,
                            ),
                            builder: (context, player) {
                              return player;
                            },
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "No hay video disponible para este ejercicio",
                              style: TextStyle(color: Colors.red[900], fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget detailItem(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 22, 22, 180),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

}




/*
class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exercise});

  static const String name = 'ExerciseDetail';
  final Exercise exercise;

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    if (widget.exercise.imageLink != null && widget.exercise.imageLink!.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.exercise.imageLink!))
        ..initialize().then((_) {
          print("Video inicializado correctamente");
          setState(() {}); // Actualiza el estado cuando el video esté listo
        }).catchError((error) {
          print("Error al cargar el video: $error"); // Log de error
        });
    } else {
      print("No hay URL de video disponible");
    }
  }


  @override
  void dispose() {
    _controller.dispose(); // Libera el controlador al salir de la pantalla
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.exercise.title, 
          style: const TextStyle(

          )
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y Descripción
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('DETALLES DEL EJERCICIO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('SERIES: ${widget.exercise.series}', style: const TextStyle(fontSize: 16)),
                        Text('REPETICIONES: ${widget.exercise.repetitions}', style: const TextStyle(fontSize: 16)),
                        Text('DESCRIPCIÓN: ${widget.exercise.description}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Video con Contenedor estilizado
              if (widget.exercise.imageLink != null && widget.exercise.imageLink!.isNotEmpty)
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: Column(
                    children: [
                      _controller.value.isInitialized
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VideoProgressIndicator(_controller, allowScrubbing: true),
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.deepPurpleAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                          });
                        },
                      ),
                    ],
                  ),
                )
              else
                Center(
                  child: Text("No hay video disponible para este ejercicio",
                      style: TextStyle(color: Colors.red[900], fontSize: 16)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

*/