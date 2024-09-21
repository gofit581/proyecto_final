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
        return 'Lose weight training';
      case TypeOfTraining.GainWeight:
        return 'Gain weight training';
      case TypeOfTraining.Running:
        return 'Running training';
      case TypeOfTraining.Strength:
        return 'Strength training'; 
      default:
        return '';
    }
  }
}