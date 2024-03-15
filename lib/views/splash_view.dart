import 'package:fit_track/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

UserProfile? userProfile;

class _SplashViewState extends State<SplashView> {
  Future<bool> _showLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userProfile');
    bool? isLoggedin = prefs.getBool('isLoggedIn');
    if (isLoggedin == null || !isLoggedin) return true;
    if (userPref == null) {
      return true;
    } else{
      userProfile = userProfileFromJson(userPref);
      return false;
    }
  }

  startTime() async {
    var duration = const Duration(seconds: 1);
    bool showLoginPage = await _showLogin();
    if (!showLoginPage) {
      print("User Already Logged In");
      return Timer(duration, navigationHomePage);
    } else {
      print("User Not Logged In. Redirecting to login page");
      return Timer(duration, navigationLoginPage);
    }
  }

  void navigationHomePage() {
    // final prefs = await SharedPreferences.getInstance();
    // String? userPref = prefs.getString('userProfile');
    print("Hello for SplashView Screen Home Page Navigation");
    Navigator.pushReplacementNamed(context, '/home', arguments: userProfile);
  }

  void navigationLoginPage() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            "assets/img/complete_workout.png",
            height: width * 0.4,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),
          // child: Image(
          //   image: const AssetImage('img/complete_workout.png'),
          //   width: width * 0.7,
          //   height: height * 0.5,
          // ),
        ),
      ),
    );
  }
}