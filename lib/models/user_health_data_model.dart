// To parse this JSON data, do
//
//     final userHealthDataModel = userHealthDataModelFromJson(jsonString);

import 'dart:convert';

UserHealthDataModel userHealthDataModelFromJson(String str) => UserHealthDataModel.fromJson(json.decode(str));

String userHealthDataModelToJson(UserHealthDataModel data) => json.encode(data.toJson());


class UserHealthDataModel {
  List<ActivityRecord>? stepCountRecordHourly;
  List<ActivityRecord>? stepCountRecordDaily;
  List<ActivityRecord>? walkTimeRecordDaily;
  int? absoluteStartStepCount;
  int? todayStepCount;
  double? todayWalkTime;
  int? totalStepCount;
  double? totalWalkTime;
  DateTime? lastUpdatedAt;

  UserHealthDataModel({
    this.stepCountRecordHourly,
    this.stepCountRecordDaily,
    this.walkTimeRecordDaily,
    this.absoluteStartStepCount,
    this.todayStepCount,
    this.todayWalkTime,
    this.totalStepCount,
    this.totalWalkTime,
    this.lastUpdatedAt,
  });

  factory UserHealthDataModel.fromJson(Map<String, dynamic> json) => UserHealthDataModel(
    stepCountRecordHourly: json["step_count_record_hourly"] == null ? [] : List<ActivityRecord>.from(json["step_count_record_hourly"]!.map((x) => ActivityRecord.fromJson(x))),
    stepCountRecordDaily: json["step_count_record_daily"] == null ? [] : List<ActivityRecord>.from(json["step_count_record_daily"]!.map((x) => ActivityRecord.fromJson(x))),
    walkTimeRecordDaily: json["walk_time_record_daily"] == null ? [] : List<ActivityRecord>.from(json["walk_time_record_daily"]!.map((x) => ActivityRecord.fromJson(x))),
    absoluteStartStepCount: json["absolute_start_step_count"],
    todayStepCount: json["today_step_count"],
    todayWalkTime: json["today_walk_time"]?.toDouble(),
    totalStepCount: json["total_step_count"],
    totalWalkTime: json["total_walk_time"]?.toDouble(),
    lastUpdatedAt: json["last_updated_at"] == null ? null : DateTime.parse(json["last_updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "step_count_record_hourly": stepCountRecordHourly == null ? [] : List<dynamic>.from(stepCountRecordHourly!.map((x) => x.toJson())),
    "step_count_record_daily": stepCountRecordDaily == null ? [] : List<dynamic>.from(stepCountRecordDaily!.map((x) => x.toJson())),
    "walk_time_record_daily": walkTimeRecordDaily == null ? [] : List<dynamic>.from(walkTimeRecordDaily!.map((x) => x.toJson())),
    "absolute_start_step_count": absoluteStartStepCount ?? 0,
    "today_step_count": todayStepCount ?? 0,
    "today_walk_time": todayWalkTime ?? 0.0,
    "total_step_count": totalStepCount ?? 0,
    "total_walk_time": totalWalkTime ?? 0.0,
    "last_updated_at": lastUpdatedAt?.toIso8601String(),
  };
}

class ActivityRecord {
  String? activityCount;
  DateTime? timestamp;

  ActivityRecord({
    this.activityCount,
    this.timestamp,
  });

  factory ActivityRecord.fromJson(Map<String, dynamic> json) => ActivityRecord(
    activityCount: json["activity_count"]?.toString(),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "activity_count": activityCount,
    "timestamp": timestamp?.toIso8601String(),
  };
}
