// step_service.dart

import 'dart:async';
import 'package:pedometer/pedometer.dart';

class StepService {
  static final StepService _instance = StepService._internal();
  StreamSubscription<StepCount>? _stepCountStreamSubscription;
  int _steps = 0;

  factory StepService() => _instance;

  StepService._internal();

  void startListening() {
    if (_stepCountStreamSubscription == null) {
      _stepCountStreamSubscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
        cancelOnError: true,
      );
    }
  }

  void stopListening() {
    _stepCountStreamSubscription?.cancel();
    _stepCountStreamSubscription = null;
  }

  void _onStepCount(StepCount event) {
    _steps = event.steps;
  }

  void _onStepCountError(Object error) {
    print('Error getting step count: $error');
  }

  int get currentSteps => _steps;
}
