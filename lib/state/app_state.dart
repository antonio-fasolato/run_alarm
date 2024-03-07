import 'package:flutter/foundation.dart';
import 'package:run_alarm/dao/training_dao.dart';

class AppState with ChangeNotifier, DiagnosticableTreeMixin  {
  final List<TrainingDao> _trainings = [];

  List<TrainingDao> get trainings => _trainings;

  addTraining(TrainingDao training) {
    _trainings.add(training);
    notifyListeners();
  }

  removeTraining(String id) {
    _trainings.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('trainings', _trainings.toString()));
  }
}