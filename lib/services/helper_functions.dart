import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double calculateDistance(double height, int steps) {
  double heightInMeters = height / 100.0;
  double stepLength = heightInMeters * 0.413;
  return (steps * stepLength)/1000; //km
}

double calculateCaloriesBurned(double weight, double distance) {
  return (0.57 * weight * distance); //kCal
}

void showToast(String msg, Color color) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

String getMonthName(int month) {
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return months[month - 1];
}