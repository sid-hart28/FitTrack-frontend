import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';


class SdService{

  SdService(){
    initPlatformState();
  }

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status ='?', _steps = '0';

  String get currentSteps => _steps;

  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }


  void onStepCount(StepCount event) {
    print("inStepsCount");
      _steps = event.steps.toString();
      print(_steps);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print("inStatus");
      _status = event.status;
  }

  void onPedestrianStatusError(error) {
    // print('onPedestrianStatusError: $error');
      _status = 'Pedestrian Status not available';
    // print(_status);
  }

  void onStepCountError(error) {
    // print('onStepCountError: $error');
      _steps = '69';
  }

  Future<void> initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    }else{

    }
  }
}