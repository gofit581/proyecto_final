import 'package:entrenador/core/entities/Trainer.dart';
import 'package:entrenador/core/entities/Clase.dart';

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
      if (_loggedUser!.diasLaborales!.contains(current.weekday)) {
        DateTime startTime = DateTime(current.year, current.month, current.day, _loggedUser!.trabajaDesdeHora!);
        DateTime endTime = DateTime(current.year, current.month, current.day, _loggedUser!.trabajaHastaHora!);

        while (startTime.isBefore(endTime)) {
          Clase clase = Clase(
            id: startTime,
            duracionHs: _loggedUser!.duracionClasesMinutos! / 60.0,
            precio: 0.0, // Asignar el precio según sea necesario
            alumno: null,
          );
          agenda.add(clase);
          startTime = startTime.add(Duration(minutes: _loggedUser!.duracionClasesMinutos!));
        }
      }
      current = current.add(Duration(days: 1));
    }

    return agenda;
  }
}