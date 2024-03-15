import 'dart:convert';

// To parse this JSON data, do
//
//     final signupRequestModel = signupRequestModelFromJson(jsonString);

SignupRequestModel signupRequestModelFromJson(String str) => SignupRequestModel.fromJson(json.decode(str));

String signupRequestModelToJson(SignupRequestModel data) => json.encode(data.toJson());

class SignupRequestModel {
  String? name;
  String? email;
  String? password;
  DateTime? dob;
  double? weight;
  double? height;

  SignupRequestModel({
    this.name,
    this.email,
    this.password,
    this.dob,
    this.weight,
    this.height,
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) => SignupRequestModel(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    weight: json["weight"]?.toDouble(),
    height: json["height"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "weight": weight,
    "height": height,
  };
}
