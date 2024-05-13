import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

List lastWorkoutArr = [
  {
    "name": "Full Body Workout",
    "image": "assets/img/Workout1.png",
    "kcal": "180",
    "time": "20",
    "progress": 0.3
  },
  {
    "name": "Lower Body Workout",
    "image": "assets/img/Workout2.png",
    "kcal": "200",
    "time": "30",
    "progress": 0.4
  },
  {
    "name": "Ab Workout",
    "image": "assets/img/Workout3.png",
    "kcal": "300",
    "time": "40",
    "progress": 0.7
  },
];

