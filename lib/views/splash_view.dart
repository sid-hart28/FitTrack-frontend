import 'package:fit_track/models/user_health_history_model.dart';
import 'package:fit_track/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

UserProfile? userProfile;

bool _isSameDay(DateTime timestamp, DateTime now) {
  return timestamp.year == now.year && timestamp.month == now.month && timestamp.day == now.day;
}

Future<void> checkForNewDay() async {
  final prefs = await SharedPreferences.getInstance();
  String? userHealthHistoryJson = prefs.getString('userHealthHistoryModel');
  UserHealthHistoryModel userHealthHistoryModel = userHealthHistoryJson == null
      ? UserHealthHistoryModel(
    todayStepCount: 0,
    todayWalkTime: 0.0,
    todayCalorie: 0.0,
    todayWaterIntake: 0.0,
    lastTimestamp: DateTime.now(),
    stepCountDaily: [],
    walkTimeDaily: [],
  )
      : userHealthHistoryModelFromJson(userHealthHistoryJson);

  DateTime now = DateTime.now();

  if(!_isSameDay(userHealthHistoryModel.lastTimestamp! , now))
    {
      userHealthHistoryModel.todayCalorie = 0.0;
      userHealthHistoryModel.todayWaterIntake = 0.0;
      userHealthHistoryModel.todayStepCount = 0;
      userHealthHistoryModel.todayWalkTime = 0.0;
    }
  await prefs.setString('userHealthHistoryModel', userHealthHistoryModelToJson(userHealthHistoryModel));
  await prefs.reload();
}


class _SplashViewState extends State<SplashView> {
  Future<bool> _showLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userProfile');
    bool? isLoggedin = prefs.getBool('isLoggedIn');
    if (isLoggedin == null || !isLoggedin) return true;
    if (userPref == null) {
      return true;
    } else{
      userProfile = userProfileFromJson(userPref);
      return false;
    }
  }

  startTime() async {
    var duration = const Duration(seconds: 1);
    await checkForNewDay();
    bool showLoginPage = await _showLogin();
    if (!showLoginPage) {
      print("User Already Logged In");
      return Timer(duration, navigationHomePage);
    } else {
      print("User Not Logged In. Redirecting to login page");
      return Timer(duration, navigationLoginPage);
    }
  }

  void navigationHomePage() {
    print("Hello for SplashView Screen Home Page Navigation");
    Navigator.pushReplacementNamed(context, '/home', arguments: userProfile);
  }

  void navigationLoginPage() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            "assets/img/complete_workout.png",
            height: width * 0.4,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),
          // child: Image(
          //   image: const AssetImage('img/complete_workout.png'),
          //   width: width * 0.7,
          //   height: height * 0.5,
          // ),
        ),
      ),
    );
  }
}