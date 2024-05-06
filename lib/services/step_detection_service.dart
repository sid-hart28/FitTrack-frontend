// import 'dart:async';
// import 'package:pedometer/pedometer.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class StepDetectionService {
//   static final StepDetectionService _instance = StepDetectionService._internal();
//   late StreamSubscription<StepCount> _stepCountStreamSubscription;
//   late StreamSubscription<PedestrianStatus> _pedestrianStatusStreamSubscription;
//   String _status = 'Unknown', _steps = '0';
//
//   // Private constructor
//   StepDetectionService._internal() {
//     _initPlatformState();
//   }
//
//   // Factory constructor to return the same instance
//   factory StepDetectionService() {
//     return _instance;
//   }
//
//   String get steps => _steps;
//
//   String get status => _status;
//
//   Future<void> _initPlatformState() async {
//     if (await Permission.activityRecognition.request().isGranted) {
//       _pedestrianStatusStreamSubscription = Pedometer.pedestrianStatusStream.listen(
//         _onPedestrianStatusChanged,
//         onError: _onPedestrianStatusError,
//         cancelOnError: true,
//       );
//
//       _stepCountStreamSubscription = Pedometer.stepCountStream.listen(
//         _onStepCount,
//         onError: _onStepCountError,
//         cancelOnError: true,
//       );
//     }
//   }
//
//   void _onStepCount(StepCount event) {
//     _steps = event.steps.toString();
//   }
//
//   void _onPedestrianStatusChanged(PedestrianStatus event) {
//     _status = event.status;
//   }
//
//   void _onPedestrianStatusError(error) {
//     _status = 'Pedestrian Status not available';
//   }
//
//   void _onStepCountError(error) {
//     _steps = 'Error getting step count';
//   }
//
//   void dispose() {
//     _stepCountStreamSubscription.cancel();
//     _pedestrianStatusStreamSubscription.cancel();
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepsDetectionService extends StatefulWidget {
  const StepsDetectionService({super.key});

  @override
  State<StepsDetectionService> createState() => _StepsDetectionServiceState();
}

class _StepsDetectionServiceState extends State<StepsDetectionService> {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status ='?', _steps = '0';
  //String _Flag = "BITSCTF{correct_flag}";

  double miles = 0;

  double duration = 30.0;
  double calories = 40.0;
  double addValue = 0.025;
  double percent = 0.5;
  double target = 1000000;
  int steps = 20;
  double previousDistacne = 0.0;
  double distance = 0.0;



  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Pedometer'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Steps Taken',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  _steps,
                  style: TextStyle(fontSize: 60),
                ),
                Divider(
                  height: 100,
                  thickness: 0,
                  color: Colors.white,
                ),
                Text(
                  'Pedestrian Status',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(
                  _status == 'walking'
                      ? Icons.directions_walk
                      : _status == 'stopped'
                      ? Icons.accessibility_new
                      : Icons.error,
                  size: 100,
                ),
                Center(
                  child: Text(
                    _status,
                    style: _status == 'walking' || _status == 'stopped'
                        ? TextStyle(fontSize: 30)
                        : TextStyle(fontSize: 20, color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  }


  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print("inStepsCount");
    setState(() {
      _steps = event.steps.toString();
      print(_steps);
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print("inStatus");
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    // print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    // print(_status);
  }

  void onStepCountError(error) {
    // print('onStepCountError: $error');
    setState(() {
      _steps = '69';
    });
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
    if (!mounted) return;
  }

}



