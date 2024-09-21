
import 'package:entrenador/core/entities/User.dart';
import 'package:entrenador/core/entities/UserManager.dart';
import 'package:flutter/material.dart';

class Calendar {
  final UserManager usManager = UserManager();

  bool isRoutineFinished() {
    final Usuario? loggedUser = usManager.getLoggedUser();
    if (loggedUser == null) return false;
    return loggedUser.timesDone.length == loggedUser.getRoutine()?.duration;
  }

  String getDialogTitle(DateTime selectedDay) {
    final dayName = getDayName(selectedDay.weekday);
    final day = selectedDay.day;
    return isDayDone(selectedDay)
        ? 'Este día ($dayName $day) entrenaste! Deseas eliminar el registro?'
        : '¿Entrenaste el $dayName $day?';
  }

  void addOrRemoveDayDone(bool dayDone, DateTime selectedDay) {
    final loggedUser = usManager.getLoggedUser();
    if (loggedUser == null) return;
    dayDone ? loggedUser.removeDayDone(selectedDay) : loggedUser.addDayDone(selectedDay);
  }

  bool isDayDone(DateTime selectedDay) {
    final loggedUser = usManager.getLoggedUser();
    return loggedUser?.timesDone.contains(selectedDay) ?? false;
  }

  String getDialogContent() {
    return isRoutineFinished() ? 'Rutina Completada' : 'Confirmar entrenamiento';
  }

  String getMonthName(int month) {
    const monthNames = [
      "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
      "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ];
    return month >= 1 && month <= 12 ? monthNames[month - 1] : '';
  }

  String getDayName(int day) {
    const dayNames = [
      "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
    ];
    return day >= 1 && day <= 7 ? dayNames[day - 1] : '';
  }
}