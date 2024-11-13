// ignore_for_file: file_names

enum TypeOfTraining {
  // ignore: constant_identifier_names
  LoseWeight,
  // ignore: constant_identifier_names
  GainWeight,
  // ignore: constant_identifier_names
  Running,
  // ignore: constant_identifier_names
  Strength,
}

extension TypeOfTrainingExtension on TypeOfTraining {
  String get name {
    switch (this) {
      case TypeOfTraining.LoseWeight:
        return 'Adelgazar';
      case TypeOfTraining.GainWeight:
        return 'Aumentar masa muscular';
      case TypeOfTraining.Running:
        return 'Cardio';
      case TypeOfTraining.Strength:
        return 'Fuerza'; 
      default:
        return '';
    }
  }
  
  String toJson() {
    return toString().split('.').last;
  } 
}