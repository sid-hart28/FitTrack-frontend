import 'package:fit_track/views/home_view.dart';
import 'package:fit_track/views/login_view.dart';
import 'package:fit_track/views/signup_view.dart';
import 'package:fit_track/views/splash_view.dart';
import 'package:flutter/material.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  // Here we'll handle all the routing
  switch (settings.name) {
    case '/home':
      return MaterialPageRoute(
          settings: settings, builder: (context) => const HomeView());
    case '/signup':
      return MaterialPageRoute(
          settings: settings, builder: (context) => const SignUpView());
    case '/login':
      return MaterialPageRoute(
          settings: settings, builder: (context) => const LoginView());
    case '/splash':
      return MaterialPageRoute(
          settings: settings, builder: (context) => SplashView());
    case '/':
      return MaterialPageRoute(
          settings: settings, builder: (context) => SplashView());
    default:
      return MaterialPageRoute(
          settings: settings, builder: (context) => SplashView());
  }
}