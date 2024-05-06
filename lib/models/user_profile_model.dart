import 'dart:convert';

// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  int? userId;
  String? name;
  DateTime? dob;
  double? weight;
  double? height;
  DateTime? creationTimestamp;

  UserProfile({
    this.userId,
    this.name,
    this.dob,
    this.weight=65,
    this.height=175,
    this.creationTimestamp,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json["userId"],
    name: json["name"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    weight: json["weight"]?.toDouble(),
    height: json["height"]?.toDouble(),
    creationTimestamp: json["creationTimestamp"] == null ? null : DateTime.parse(json["creationTimestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "weight": weight,
    "height": height,
    "creationTimestamp": creationTimestamp?.toIso8601String(),
  };
}
