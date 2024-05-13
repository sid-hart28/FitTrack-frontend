import 'package:fit_track/utils/colors.dart';
import 'package:fit_track/routes.dart';

import 'package:flutter/material.dart';


// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


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

