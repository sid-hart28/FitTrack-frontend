import 'package:fit_track/utils/colors.dart';
import 'package:fit_track/routes.dart';
import 'package:fit_track/views/home_view.dart';
import 'package:fit_track/views/signup_view.dart';
import 'package:flutter/material.dart';

void main() {
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