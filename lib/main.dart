import 'package:fit_track/utils/colors.dart';
import 'package:fit_track/views/home_view.dart';
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
      home: const HomeView(),
      // initialRoute: '/',
      // onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
      title: "FitTrack",
      theme: ThemeData(primaryColor: TColor.primaryColor1),
    );
  }
}