import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:fit_track/services/background_service.dart';
import 'package:fit_track/utils/colors.dart';
import 'package:fit_track/routes.dart';
import 'package:fit_track/views/home_view.dart';
import 'package:fit_track/views/signup_view.dart';

import 'package:flutter/material.dart';


import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await requestPermissionsAndInitializeService();
  // await AndroidAlarmManager.initialize();
  // await reInitializeApp();
  runApp(const MyApp());
}

// Future<void> reInitializeApp() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//   if (isLoggedIn) {
//     var status = await Permission.activityRecognition.request();
//
//     if (status.isGranted) {
//       await initializeService(); // Initialize service if user is already logged in
//     } else {
//       print("Permissions not granted");
//     }
//   }
// }

// Future<void> requestPermissionsAndInitializeService() async {
//   var status = await Permission.activityRecognition.request();
//   if (status.isGranted) {
//     // Initialize the background service only if permissions are granted
//     await initializeService();
//   } else {
//     // Handle the case where permissions are not granted
//     print("Permissions not granted");
//   }
// }



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
      title: "FitTrack",
      theme: ThemeData(primaryColor: TColor.primaryColor1),
    );
  }
}

