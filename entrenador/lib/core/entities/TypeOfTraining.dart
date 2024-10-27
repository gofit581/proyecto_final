enum TypeOfTraining {
  LoseWeight,
  GainWeight,
  Running,
  Strength,
  Abs,
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
      case TypeOfTraining.Abs:
        return 'Full abs'; 
 
      default:
        return '';
    }
  }

  String toJson() {
    return toString().split('.').last;
  }
}