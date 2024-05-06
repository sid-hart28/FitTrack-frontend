// import 'dart:async';
// import 'dart:io';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fit_track/services/step_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// const String _channelId = 'fit_track_alarm';
// const String _channelTitle = 'FitTrack Alarm';
// const String _channelDescription = 'Alarm for step count data saving';
// const int _notificationId = 999;
//
// @pragma('vm:entry-point')
// Future<void> alarmCallback() async {
//   final stepService = StepService();
//
//   // Start listening for step data
//   stepService.startListening();
//   await Future.delayed(const Duration(seconds: 5));  // Allow time for steps to accumulate
//
//   int currentSteps = stepService.currentSteps;
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   List<String> timestamps = preferences.getStringList('timestamps') ?? [];
//   String currentTimestamp = DateTime.now().toIso8601String();
//
//   String entry = '$currentSteps at $currentTimestamp';
//   timestamps.add(entry);
//   await preferences.setStringList('timestamps', timestamps);
//
//   stepService.stopListening();
//
//   print('Alarm triggered: $entry');
//
//   final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   // Optional: Showing a notification after the alarm task completes
//   if (Platform.isIOS || Platform.isAndroid) {
//     await notificationsPlugin.initialize(
//       const InitializationSettings(
//         iOS: DarwinInitializationSettings(),
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//
//     notificationsPlugin.show(
//       _notificationId,
//       'Step Data Saved',
//       'Saved at $currentTimestamp',
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channelId,
//           _channelTitle,
//           channelDescription: _channelDescription,
//           importance: Importance.high,
//           priority: Priority.high,
//           icon: 'ic_bg_service_small',
//         ),
//       ),
//     );
//   }
// }
//
// Future<void> scheduleAlarm() async {
//   // Scheduling the alarm to trigger every hour
//   DateTime now = DateTime.now();
//   print(now);
//   await AndroidAlarmManager.periodic(
//     const Duration(minutes: 16),
//     0, // Unique alarm ID
//     alarmCallback,
//     startAt: DateTime(now.year, now.month, now.day, 0, 42),
//     wakeup: true, // Ensures the alarm works even if the device is asleep
//     allowWhileIdle: true,
//     rescheduleOnReboot: true,
//   );
// }
