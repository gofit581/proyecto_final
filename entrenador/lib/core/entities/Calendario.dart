// ignore_for_file: file_names

class Calendar {

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