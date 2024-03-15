import 'user_profile_model.dart';
import 'dart:convert';

// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);


LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  int? status;
  String? message;
  UserProfile? userProfile;

  LoginResponseModel({
    this.status,
    this.message,
    this.userProfile,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    status: json["status"],
    message: json["message"],
    userProfile: json["userProfile"] == null ? null : UserProfile.fromJson(json["userProfile"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "userProfile": userProfile?.toJson(),
  };
}
