import 'dart:convert';

WalkingHistoryModel walkingHistoryModelFromJson(String str) => WalkingHistoryModel.fromJson(json.decode(str));

String walkingHistoryModelToJson(WalkingHistoryModel data) => json.encode(data.toJson());

class WalkingHistoryModel {
  List<WalkingHistory>? walkingHistoryList;

  WalkingHistoryModel({
    this.walkingHistoryList,
  });

  factory WalkingHistoryModel.fromJson(Map<String, dynamic> json) => WalkingHistoryModel(
    walkingHistoryList: json["walking_history_list"] == null ? [] : List<WalkingHistory>.from(json["walking_history_list"]!.map((x) => WalkingHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "walking_history_list": walkingHistoryList == null ? [] : List<dynamic>.from(walkingHistoryList!.map((x) => x.toJson())),
  };
}

class WalkingHistory {
  int? steps;
  double? duration;
  DateTime? timestamp;

  WalkingHistory({
    this.steps,
    this.duration,
    this.timestamp,
  });

  factory WalkingHistory.fromJson(Map<String, dynamic> json) => WalkingHistory(
    steps: json["steps"],
    duration: json["duration"]?.toDouble(),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "steps": steps,
    "duration": duration,
    "timestamp": timestamp?.toIso8601String(),
  };
}
