import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:flutter/material.dart';

class Calendar {
  UserManager us_manager = UserManager();

  bool isRoutineFinished() {
    Usuario? loggedUser = us_manager.getLoggedUser();
    return us_manager.getLoggedUser()!.timesDone.length ==
        us_manager.getLoggedUser()!.getRoutine()!.duration;
  }

  String getDialogTitle(DateTime selectedDay) {
    String texto = '';
    if (isDayDone(selectedDay)) {
      texto =
          'Este día (${getDayName(selectedDay.weekday)} ${selectedDay.day}) entrenaste! Deseas eliminar el registro?';
    } else {
      texto = '¿Entrenaste el ${getDayName(selectedDay.weekday)} ${selectedDay.day}?';
    }
    return texto;
  }

  void addOrRemoveDayDone(bool dayDone, DateTime selectedDay) {
    if (!dayDone) {
      us_manager.getLoggedUser()!.addDayDone(selectedDay);
    } else {
      us_manager.getLoggedUser()!.removeDayDone(selectedDay);
    }
  }

  bool isDayDone(DateTime selectedDay){
    return us_manager.getLoggedUser()!.timesDone.contains(selectedDay);
  }
  String getDialogContent() {
    String text = "";
    if (isRoutineFinished()) {
      text = 'Rutina Completada';
    } else {
      text = 'Confirmar entrenamiento';
    }
    return text;
  }

  String getMonthName(int month) {
    String es_month = "";
    switch (month) {
      case 1:
        es_month = "Enero";
        break;
      case 2:
        es_month = "Febrero";
        break;
      case 3:
        es_month = "Marzo";
        break;
      case 4:
        es_month = "Abril";
        break;
      case 5:
        es_month = "Mayo";
        break;
      case 6:
        es_month = "Junio";
        break;
      case 7:
        es_month = "Julio";
        break;
      case 8:
        es_month = "Agosto";
        break;
      case 9:
        es_month = "Septiembre";
        break;
      case 10:
        es_month = "Octubre";
        break;
      case 11:
        es_month = "Noviembre";
        break;
      case 12:
        es_month = "Diciembre";
        break;
    }
    return es_month;
  }

  String getDayName(int day) {
    String dia = "";
    switch (day) {
      case 1:
        dia = "Lunes";
        break;
      case 2:
        dia = "Martes";
        break;
      case 3:
        dia = "Miércoles";
        break;
      case 4:
        dia = "Jueves";
        break;
      case 5:
        dia = "Viernes";
        break;
      case 6:
        dia = "Sábado";
        break;
      case 7:
        dia = "Domingo";
        break;
    }
    return dia;
  }
}