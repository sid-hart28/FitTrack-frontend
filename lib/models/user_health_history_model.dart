import 'dart:convert';

UserHealthHistoryModel userHealthHistoryModelFromJson(String str) => UserHealthHistoryModel.fromJson(json.decode(str));

String userHealthHistoryModelToJson(UserHealthHistoryModel data) => json.encode(data.toJson());

class UserHealthHistoryModel {
  int? todayStepCount;
  double? todayWalkTime;
  double? todayCalorie;
  double? todayWaterIntake;
  DateTime? lastTimestamp;
  List<Daily>? stepCountDaily;
  List<Daily>? walkTimeDaily;

  UserHealthHistoryModel({
    this.todayStepCount,
    this.todayWalkTime,
    this.todayCalorie,
    this.todayWaterIntake,
    this.lastTimestamp,
    this.stepCountDaily,
    this.walkTimeDaily,
  });

  factory UserHealthHistoryModel.fromJson(Map<String, dynamic> json) => UserHealthHistoryModel(
    todayStepCount: json["today_step_count"],
    todayWalkTime: json["today_walk_time"]?.toDouble(),
    todayCalorie: json["today_calorie"]?.toDouble(),
    todayWaterIntake: json["today_water_intake"]?.toDouble(),
    lastTimestamp: json["last_timestamp"] == null ? null : DateTime.parse(json["last_timestamp"]),
    stepCountDaily: json["step_count_daily"] == null ? [] : List<Daily>.from(json["step_count_daily"]!.map((x) => Daily.fromJson(x))),
    walkTimeDaily: json["walk_time_daily"] == null ? [] : List<Daily>.from(json["walk_time_daily"]!.map((x) => Daily.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "today_step_count": todayStepCount,
    "today_walk_time": todayWalkTime,
    "today_calorie": todayCalorie,
    "today_water_intake": todayWaterIntake,
    "last_timestamp": lastTimestamp?.toIso8601String(),
    "step_count_daily": stepCountDaily == null ? [] : List<dynamic>.from(stepCountDaily!.map((x) => x.toJson())),
    "walk_time_daily": walkTimeDaily == null ? [] : List<dynamic>.from(walkTimeDaily!.map((x) => x.toJson())),
  };
}

class Daily {
  String? activityCount;
  DateTime? timestamp;

  Daily({
    this.activityCount,
    this.timestamp,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
    activityCount: json["activity_count"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "activity_count": activityCount,
    "timestamp": timestamp?.toIso8601String(),
  };
}
