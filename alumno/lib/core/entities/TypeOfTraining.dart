enum TypeOfTraining {
  LoseWeight,
  GainWeight,
  Running,
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
}