import 'package:entrenador/core/entities/Trainer.dart';
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

  List<Clase> generarAgenda(DateTime desde, DateTime hasta) {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }

    List<Clase> agenda = [];
    DateTime current = desde;

    while (current.isBefore(hasta) || current.isAtSameMomentAs(hasta)) {
      // Verificar si el día actual está en los días laborales del entrenador
      if (_loggedUser!.diasLaborales!.contains(current.weekday % 7)) {
        DateTime startTime = DateTime(current.year, current.month, current.day,
            _loggedUser!.trabajaDesdeHora!);
        DateTime endTime = DateTime(current.year, current.month, current.day,
            _loggedUser!.trabajaHastaHora!);

        while (startTime.isBefore(endTime)) {
          Clase clase = Clase(
            horaInicio: startTime,
            duracionHs: _loggedUser!.duracionClasesMinutos!,
            precio: _loggedUser!.precioPorClase!,
            alumno: null,
          );
          agenda.add(clase);
          startTime = startTime
              .add(Duration(minutes: _loggedUser!.duracionClasesMinutos!));
        }
      }
      current = current.add(const Duration(days: 1));
    }
    _loggedUser!.agenda = agenda;
    print(_loggedUser.toString());
    for (var clase in agenda) {
      print(
          'Clase: ${clase.horaInicio} - ${clase.duracionHs}hs - \$${clase.precio}');
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

  Future<void> borrarClaseId(Clase clase) async {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }

    final String url =
        'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase/${clase.id}';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _loggedUser?.agenda?.removeWhere((c) => c.id == clase.id);
      } else {
        throw Exception('Error al borrar la clase: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al borrar la clase: $e');
      throw Exception('Error al borrar la clase');
    }
  }

  Future<void> borraClases() async {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }

    final trainerCode = _loggedUser!.getTrainerCode();

    // Hacer un GET para obtener todas las clases
    final response = await http.get(
      Uri.parse('https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las clases: ${response.reasonPhrase}');
    }

    List<dynamic> clasesData = jsonDecode(response.body);

    // Filtrar las clases que pertenezcan al entrenador logueado
    List<dynamic> clasesParaBorrar = clasesData.where((clase) {
      return clase['idTrainer'] == trainerCode;
    }).toList();

    // Borrar cada clase filtrada
    for (var clase in clasesParaBorrar) {
      final deleteResponse = await http.delete(
        Uri.parse(
            'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase/${clase['id']}'),
      );

      if (deleteResponse.statusCode != 200) {
        throw Exception(
            'Error al borrar la clase con id ${clase['id']}: ${deleteResponse.reasonPhrase}');
      }
    }
  }

  Future<void> actualizarAgenda() async {
    if (_loggedUser == null) {
      throw Exception("No hay un entrenador logueado.");
    }

    final trainerCode = _loggedUser!.getTrainerCode();

    // Obtener las clases existentes en la base de datos para el entrenador logueado
    final response = await http.get(
      Uri.parse('https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las clases: ${response.reasonPhrase}');
    }

    List<dynamic> clasesData = jsonDecode(response.body);

    // Filtrar las clases que pertenezcan al entrenador logueado
    List<dynamic> clasesEnBaseDeDatos = clasesData.where((clase) {
      return clase['idTrainer'] == trainerCode;
    }).toList();

    // Obtener los IDs de las clases de la agenda
    List<String?> idsAgenda =
        _loggedUser!.agenda!.map((clase) => clase.id).toList();

    // Encontrar clases para borrar (están en la base de datos pero no en la agenda)
    List<dynamic> clasesParaBorrar = clasesEnBaseDeDatos.where((claseBD) {
      return !idsAgenda.contains(claseBD['id']);
    }).toList();

    // Borrar clases que no están en la agenda
    for (var clase in clasesParaBorrar) {
      final deleteResponse = await http.delete(
        Uri.parse(
            'https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase/${clase['id']}'),
      );

      if (deleteResponse.statusCode != 200) {
        throw Exception(
            'Error al borrar la clase con id ${clase['id']}: ${deleteResponse.reasonPhrase}');
      }

      print('Clase borrada correctamente: ${clase['id']}');
    }

    // Obtener los IDs de las clases en la base de datos
    List idsBaseDeDatos =
        clasesEnBaseDeDatos.map((claseBD) => claseBD['id']).toList();

    // Encontrar clases para agregar (están en la agenda pero no en la base de datos)
    List<Map<String, dynamic>> clasesParaAgregar =
        _loggedUser!.agenda!.where((clase) {
      return !idsBaseDeDatos.contains(clase.id);
    }).map((clase) {
      return {
        "horaInicio": clase.horaInicio.toIso8601String(),
        "precio": clase.precio,
        "duracionHs": clase.duracionHs,
        "alumno": clase.alumno,
        "idTrainer": trainerCode,
      };
    }).toList();

    // Agregar clases que no están en la base de datos
    for (var claseData in clasesParaAgregar) {
      final response = await http.post(
        Uri.parse('https://66ff0a2d2b9aac9c997e1fdd.mockapi.io/api/clase'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(claseData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al agregar la clase: ${response.reasonPhrase}');
      }

      // Debug log para confirmar cada clase enviada correctamente
      print('Clase agregada correctamente: ${claseData}');
    }

    // Actualizar la agenda en la memoria
    print('Agenda actualizada correctamente.');
  }
}
