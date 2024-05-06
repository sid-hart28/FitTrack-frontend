

import 'package:fit_track/models/user_health_history_model.dart';
import 'package:fit_track/models/walking_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fit_track/models/walking_history_model.dart';
import 'package:fit_track/models/user_health_history_model.dart';
import 'dart:convert';

Future<void> printWalkingHistoryList() async{
  final prefs = await SharedPreferences.getInstance();
  // await prefs.reload();

  // Retrieve existing data for WalkingHistoryModel
  String? walkingHistoryJson = prefs.getString('walkingHistoryModel');
  WalkingHistoryModel walkingHistoryModel = walkingHistoryJson == null
      ? WalkingHistoryModel(walkingHistoryList: [])
      : walkingHistoryModelFromJson(walkingHistoryJson);
  print(walkingHistoryModel.walkingHistoryList!.length);
}

Future<void> saveStepData(int steps, double duration, double calories) async {
  print("steps:- $steps, duration:- $duration, calories:- $calories");
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();

  // Retrieve existing data for WalkingHistoryModel
  String? walkingHistoryJson = prefs.getString('walkingHistoryModel');
  WalkingHistoryModel walkingHistoryModel = walkingHistoryJson == null
      ? WalkingHistoryModel(walkingHistoryList: [])
      : walkingHistoryModelFromJson(walkingHistoryJson);

  // Retrieve existing data for UserHealthHistoryModel
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

  // Update WalkingHistoryModel
  if (walkingHistoryModel.walkingHistoryList!.length > 10) {
    walkingHistoryModel.walkingHistoryList!.removeAt(0);
  }

  print("length1 :- ${walkingHistoryModel.walkingHistoryList!.length}");

  walkingHistoryModel.walkingHistoryList?.add(WalkingHistory(
    steps: steps,
    duration: duration,
    timestamp: now,
  ));
  print("length2 :- ${walkingHistoryModel.walkingHistoryList!.length}");

  await prefs.setString('walkingHistoryModel', walkingHistoryModelToJson(walkingHistoryModel));

  // Update UserHealthHistoryModel
  userHealthHistoryModel.todayStepCount = (userHealthHistoryModel.todayStepCount ?? 0) + steps;
  userHealthHistoryModel.todayWalkTime = (userHealthHistoryModel.todayWalkTime ?? 0.0) + duration;
  userHealthHistoryModel.todayCalorie = (userHealthHistoryModel.todayCalorie ?? 0.0) + calories;
  userHealthHistoryModel.lastTimestamp = now;

  if (userHealthHistoryModel.stepCountDaily!.length >= 5) {
    userHealthHistoryModel.stepCountDaily!.removeAt(0);
  }

  if (userHealthHistoryModel.walkTimeDaily!.length >= 5) {
    userHealthHistoryModel.walkTimeDaily!.removeAt(0);
  }

  _updateLastDailyEntry(userHealthHistoryModel.stepCountDaily!, userHealthHistoryModel.todayStepCount.toString(), now);
  _updateLastDailyEntry(userHealthHistoryModel.walkTimeDaily!, userHealthHistoryModel.todayWalkTime.toString(), now);

  await prefs.setString('userHealthHistoryModel', userHealthHistoryModelToJson(userHealthHistoryModel));
}

void _updateLastDailyEntry(List<Daily> dailyList, String count, DateTime now) {
  if (dailyList.isEmpty) {
    dailyList.add(Daily(activityCount: count, timestamp: now));
    return;
  }

  Daily lastEntry = dailyList.last;
  if (_isSameDay(lastEntry.timestamp!, now)) {
    lastEntry.activityCount = count;
    lastEntry.timestamp = now;
  } else {
    dailyList.add(Daily(activityCount: count, timestamp: now));
  }
}

bool _isSameDay(DateTime timestamp, DateTime now) {
  return timestamp.year == now.year && timestamp.month == now.month && timestamp.day == now.day;
}




Future<void> saveWaterIntake(double water) async {
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

  // Update today's data
  userHealthHistoryModel.todayWaterIntake = (userHealthHistoryModel.todayWaterIntake ?? 0.0) + water;
  userHealthHistoryModel.lastTimestamp = DateTime.now();

  await prefs.setString('userHealthHistoryModel', userHealthHistoryModelToJson(userHealthHistoryModel));
}
