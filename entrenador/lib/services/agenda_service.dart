import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/Clase.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendaService {
  Trainer? _loggedUser;

  void setLoggedUser(Trainer trainer) {
    _loggedUser = trainer;
  }

  List<Clase> generarAgenda(DateTime desde, DateTime hasta) {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }

    List<Clase> agenda = [];
    DateTime current = desde;

    while (current.isBefore(hasta) || current.isAtSameMomentAs(hasta)) {
        DateTime startTime = DateTime(current.year, current.month, current.day, _loggedUser!.trabajaDesdeHora!);
        DateTime endTime = DateTime(current.year, current.month, current.day, _loggedUser!.trabajaHastaHora!);

        while (startTime.isBefore(endTime)) {
          Clase clase = Clase(
            id: startTime,
            duracionHs: _loggedUser!.duracionClasesMinutos! ~/ 60,
            precio: _loggedUser!.precioPorClase!,
            alumno: null,
          );
          agenda.add(clase);
          startTime = startTime.add(Duration(minutes: _loggedUser!.duracionClasesMinutos!));
        }
      
      current = current.add(const Duration(days: 1));
    }
    actualizarAgenda();
    return agenda;
  }

void borrarClase(Clase clase) {
  if (_loggedUser == null) {
    throw Exception("No hay un entrenador logueado.");
  }
  _loggedUser?.agenda?.removeWhere((c) => c.id == clase.id);
  actualizarAgenda();
}


Future<void> actualizarAgenda() async {
  if (_loggedUser == null) {
    throw Exception("No hay un entrenador logueado.");
  }

  List<Clase>? agenda = _loggedUser?.agenda;
  if (agenda == null || agenda.isEmpty) {
    throw Exception("La agenda está vacía.");
  }

  List<Map<String, dynamic>> clasesData = agenda.map((clase) {
    return {
      "horaInicio": clase.id.millisecondsSinceEpoch,
      "precio": clase.precio,
      "duracionHs": clase.duracionHs,
      "alumno": clase.alumno != null ? clase.alumno!.toJson() : {},
      "idTrainer": _loggedUser!.id,
      "id": clase.id.toString(),
    };
  }).toList();

  final response = await http.put(
    Uri.parse('https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(clasesData),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al actualizar la agenda: ${response.reasonPhrase}');
  }
}
}