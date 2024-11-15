import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/core/entities/Clase.dart';
import 'package:entrenador/core/entities/TrainerManager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendaService {
  TrainerManager manager = TrainerManager();
  Trainer? _loggedUser;

  AgendaService() {
    _loggedUser = manager.getLoggedUser();
  }

  void setLoggedUser(Trainer trainer) {
    _loggedUser = trainer;
  }

  Future<List<Clase>> generarAgenda(DateTime desde, DateTime hasta) async {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }
    List<Clase> agendaPrevia = await obtenerAgendaClases();
    List<Clase> agendaNueva = [];
    DateTime current = desde;
    List<DateTime> fechasOcupadas = [];
    for (var clase in agendaPrevia) {
      DateTime fechaClase = DateTime(
          clase.horaInicio.year, clase.horaInicio.month, clase.horaInicio.day);
      if (fechaClase.isAfter(desde.subtract(const Duration(days: 1))) &&
          fechaClase.isBefore(hasta.add(const Duration(days: 1)))) {
        fechasOcupadas.add(fechaClase);
      }
    }
    if (fechasOcupadas.isNotEmpty && _loggedUser!.agenda != null && _loggedUser!.agenda!.isNotEmpty) {
      String fechasConflictivas = fechasOcupadas
          .map((fecha) => "${fecha.day}/${fecha.month}")
          .join(", ");
      throw Exception(
          "Ya existe una agenda dada de alta para la(s) fecha(s): $fechasConflictivas");
    }
    while (current.isBefore(hasta) || current.isAtSameMomentAs(hasta)) {
      if (_loggedUser!.diasLaborales!.contains(current.weekday % 7)) {
        if (_loggedUser!.trabajaDesdeHora == null ||
            _loggedUser!.trabajaHastaHora == null) {
          throw Exception(
              "Horas de trabajo no configuradas para el entrenador logueado.");
        }
        DateTime startTime = DateTime(current.year, current.month, current.day, _loggedUser!.trabajaDesdeHora!);
        DateTime endTime = DateTime(current.year, current.month, current.day, _loggedUser!.trabajaHastaHora!);
        while (startTime.isBefore(endTime)) {
          Clase clase = Clase(
            horaInicio: startTime,
            duracionHs: _loggedUser!.duracionClasesMinutos!,
            precio: _loggedUser!.precioPorClase!,
            alumno: null,
          );
          agendaNueva.add(clase);
          startTime = startTime
              .add(Duration(minutes: _loggedUser!.duracionClasesMinutos!));
        }
      }
      current = current.add(const Duration(days: 1));
    }
    await guardarClasesNuevas(agendaNueva);
    agendaNueva= await obtenerAgendaClases();
    for (var clase in agendaNueva) {
      _loggedUser!.agenda!.add(clase);
    }
    return agendaNueva;
  }

  Future<void> guardarClasesNuevas(List<Clase> nuevasClases) async {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }
    final trainerCode = _loggedUser!.getTrainerCode();
    final response = await http.get(
      Uri.parse('https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las clases: ${response.reasonPhrase}');
    }
    List<dynamic> clasesData = jsonDecode(response.body);
    List<dynamic> clasesExistentes = clasesData.where((clase) {
      return clase['idTrainer'] == trainerCode;
    }).toList();
    for (var nuevaClase in nuevasClases) {
      var claseExistente = clasesExistentes.firstWhere(
          (clase) =>
              clase['horaInicio'] == nuevaClase.horaInicio.toIso8601String(),
          orElse: () => null);

      if (claseExistente != null) {
        final putResponse = await http.put(
          Uri.parse('https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase/${claseExistente['id']}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "horaInicio": nuevaClase.horaInicio.toIso8601String(),
            "precio": nuevaClase.precio,
            "duracionHs": nuevaClase.duracionHs,
            "alumno": nuevaClase.alumno,
            "idTrainer": trainerCode,
          }),
        );
        if (putResponse.statusCode != 200) {
          throw Exception('Error al actualizar la clase: ${putResponse.reasonPhrase}');
        }
      } else {
        final postResponse = await http.post(Uri.parse('https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "horaInicio": nuevaClase.horaInicio.toIso8601String(),
            "precio": nuevaClase.precio,
            "duracionHs": nuevaClase.duracionHs,
            "alumno": nuevaClase.alumno,
            "idTrainer": trainerCode,
          }),
        );
        if (postResponse.statusCode != 200 && postResponse.statusCode != 201) {
          throw Exception('Error al agregar la clase: ${postResponse.reasonPhrase}');
        }
      }
    }
    // ignore: avoid_print
    print('Clases nuevas guardadas correctamente.');
  }

  Future<List<Clase>> obtenerAgendaClases() async {
    const String claseEndpoint ='https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase';
    final claseResponse = await http.get(
      Uri.parse(claseEndpoint),
      headers: {'Content-Type': 'application/json'},
    );
    if (claseResponse.statusCode == 200) {
      final List<dynamic> clasesData = jsonDecode(claseResponse.body);
      final List<Clase> agenda = clasesData
          .where((claseData) =>
              claseData['idTrainer'] == _loggedUser?.getTrainerCode())
          .map((claseData) => Clase(
                id: claseData['id'],
                horaInicio: DateTime.parse(claseData['horaInicio']),
                duracionHs: claseData['duracionHs'],
                alumno: claseData['alumno'] != null
                    ? Usuario.fromJson(claseData['alumno'])
                    : null,
                precio: claseData['precio'].toDouble(),
              ))
          .toList();
      return agenda;
    } else {
      throw Exception('Failed to load class data');
    }
  }

  Future<void> borrarClaseId(Clase clase) async {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }
    print(clase.id);
    final String url = 'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase/${clase.id}';
    try {
      final response = await http.delete( Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _loggedUser?.agenda?.removeWhere((c) => c.id == clase.id);
      } else {
        throw Exception('Error al borrar la clase: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al borrar la clase: $e');
      throw Exception('Error al borrar la clase');
    }
  }
}
