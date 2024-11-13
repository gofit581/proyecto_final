// ignore_for_file: file_names

import 'package:entrenador/core/entities/TrainerManager.dart';

class Calendar {
  TrainerManager usManager = TrainerManager();


  String getMonthName(int month) {
    String esMonth = "";
    switch (month) {
      case 1:
        esMonth = "Enero";
        break;
      case 2:
        esMonth = "Febrero";
        break;
      case 3:
        esMonth = "Marzo";
        break;
      case 4:
        esMonth = "Abril";
        break;
      case 5:
        esMonth = "Mayo";
        break;
      case 6:
        esMonth = "Junio";
        break;
      case 7:
        esMonth = "Julio";
        break;
      case 8:
        esMonth = "Agosto";
        break;
      case 9:
        esMonth = "Septiembre";
        break;
      case 10:
        esMonth = "Octubre";
        break;
      case 11:
        esMonth = "Noviembre";
        break;
      case 12:
        esMonth = "Diciembre";
        break;
    }
    return esMonth;
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