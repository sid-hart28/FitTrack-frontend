import 'package:fit_track/models/user_health_data_model.dart';
import 'package:fit_track/models/user_profile_model.dart';
import 'package:fit_track/utils/helper_functions.dart';
import 'package:fit_track/services/shared_pref_service.dart';
import 'package:fit_track/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/scheduler.dart';
import 'package:fit_track/utils/colors.dart';
import 'package:fit_track/utils/widgets/round_button.dart';

class WalkingTrackerView extends StatefulWidget {
  final UserProfile userProfile;
  const WalkingTrackerView({super.key,required this.userProfile});

  @override
  State<WalkingTrackerView> createState() => _WalkingTrackerViewState();
}

class _WalkingTrackerViewState extends State<WalkingTrackerView>
    with SingleTickerProviderStateMixin {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  UserProfile? userProfile;
  String _status = 'start walking';
  int _initialStepCount = 0;
  int _currentStepCount = 0;
  int _steps = 0;

  late Ticker _ticker;
  int _secondsElapsed = 0;
  int _previousElapsedTime = 0;
  DateTime _startTime = DateTime.now();

  double distance = 0.0;
  double caloriesBurned = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      userProfile = widget.userProfile;
    });
    initPlatformState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _secondsElapsed = _previousElapsedTime + elapsed.inSeconds;
      });
    });
  }

  void startTimer() {
    _startTime = DateTime.now();
    _ticker.start();
  }

  void stopTimer() {
    _ticker.stop();
    _previousElapsedTime = _secondsElapsed;
  }

  void onStepCount(StepCount event) {
    if (!mounted) return;
    if (_initialStepCount == 0) {
      _initialStepCount = event.steps;
    }
    _currentStepCount = event.steps;
    setState(() {
      _steps = _currentStepCount - _initialStepCount;
      distance = calculateDistance(userProfile?.height ?? 175 , _steps);
      caloriesBurned = calculateCaloriesBurned(userProfile?.weight ?? 65, distance);
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (!mounted) return;
    setState(() {
      _status = event.status;
      if (_status == 'walking') {
        if (!_ticker.isTicking) {
          startTimer();
        }
      } else {
        stopTimer();
      }
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'NA';
    });
    stopTimer();
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 0;
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
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var minutes = _secondsElapsed ~/ 60;
    var seconds = _secondsElapsed % 60;
    var hours = _secondsElapsed ~/ 3600;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop) {
          await saveStepData(_steps, _secondsElapsed / 60, caloriesBurned);
          showToast('$_steps Steps saved', Colors.green);
          // Navigator.popAndPushNamed(context, '/home', arguments: userProfile);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Walking Tracker'),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    RoundedCard(
                      width: media.width * 0.6,
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Elapsed Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '$hours : $minutes : $seconds',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      backgroundColor: TColor.primaryColor2.withOpacity(0.5),
                      radius: 85,
                      child: Icon(
                        _status == 'walking'
                            ? Icons.directions_walk
                            : _status == 'stopped'
                            ? Icons.accessibility_new
                            : Icons.error,
                        size: 140,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: media.width * 0.4,
                      height: 100,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: TColor.primaryColor2.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _steps.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Steps',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: media.width * 0.4,
                      height: 100,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: TColor.primaryColor2.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                caloriesBurned.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                '  kCal'
                              ),
                            ],
                          ),
                          const Text(
                            'Calories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RoundedCard(
                  width: media.width * 0.6,
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Distance walked',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${(distance*1000).toStringAsFixed(0)} m',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                RoundButton(
                  title: "End Walk",
                  type: RoundButtonType.bgSGradient,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    // await saveStepData(_steps, _secondsElapsed / 60, caloriesBurned);
                    // showToast('Steps saved', Colors.green);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    super.key,
    required this.widget,
    this.height = 80,
    this.width = 400,
  });

  final Widget widget;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: widget,
    );
  }
}
