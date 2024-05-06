// import 'dart:async';
// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:fit_track/models/user_health_data_model.dart';
// import 'package:fit_track/services/step_service.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// // const String _channelId = 'fit_track_foreground';
// // const String _channelTitle = 'FitTrack Foreground Service';
// // const String _channelDescription = 'This channel is used for important notifications';
// // const int _fgServiceNotificationId = 888;
//
//
// // Future<void> initializeService() async {
// //   final service = FlutterBackgroundService();
// //
// //   /// OPTIONAL, using custom notification channel id
// //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //     _channelId, // id
// //     _channelTitle, // title
// //     description: _channelDescription, // description
// //     importance: Importance.high, // importance must be at low or higher level
// //   );
// //
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   if (Platform.isIOS || Platform.isAndroid) {
// //     await flutterLocalNotificationsPlugin.initialize(
// //       const InitializationSettings(
// //         iOS: DarwinInitializationSettings(),
// //         android: AndroidInitializationSettings('ic_bg_service_small'),
// //       ),
// //     );
// //   }
// //
// //   await flutterLocalNotificationsPlugin
// //       .resolvePlatformSpecificImplementation<
// //       AndroidFlutterLocalNotificationsPlugin>()
// //       ?.createNotificationChannel(channel);
// //
// //   await service.configure(
// //     androidConfiguration: AndroidConfiguration(
// //       // this will be executed when app is in foreground or background in separated isolate
// //       onStart: onStart,
// //
// //       // auto start service
// //       autoStart: true,
// //       autoStartOnBoot: true,
// //       isForegroundMode: true,
// //
// //       notificationChannelId: _channelId,
// //       initialNotificationTitle: _channelTitle,
// //       initialNotificationContent: 'Initializing',
// //       foregroundServiceNotificationId: _fgServiceNotificationId,
// //     ),
// //     iosConfiguration: IosConfiguration(
// //     ),
// //   );
// // }
// //
// //
// //
// // @pragma('vm:entry-point')
// // void onStart(ServiceInstance service) async {
// //   // Only available for flutter 3.0.0 and later
// //   DartPluginRegistrant.ensureInitialized();
// //
// //
// //   final stepService = StepService();
// //   // For flutter prior to version 3.0.0
// //   // We have to register the plugin manually
// //
// //   /// OPTIONAL when use custom notification
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //
// //   // StreamSubscription<StepCount>? stepSubscription;
// //   // int steps = 0;
// //   //
// //   // stepSubscription = Pedometer.stepCountStream.listen(
// //   //       (event) {
// //   //     steps = event.steps;
// //   //     print("Steps: $steps");
// //   //   },
// //   //   onError: (error) => print("StepCount Error: $error"),
// //   //   cancelOnError: true,
// //   // );
// //
// //
// //   if (service is AndroidServiceInstance) {
// //     service.on('setAsForeground').listen((event) {
// //       service.setAsForegroundService();
// //     });
// //
// //     service.on('setAsBackground').listen((event) {
// //       service.setAsBackgroundService();
// //     });
// //   }
// //
// //   service.on('stopService').listen((event) {
// //     service.stopSelf();
// //   });
// //
// //   // bring to foreground
// //   Timer.periodic(const Duration(minutes: 3), (timer) async {
// //     if (service is AndroidServiceInstance) {
// //       if (await service.isForegroundService()) {
// //         /// OPTIONAL for use custom notification
// //         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
// //
// //         flutterLocalNotificationsPlugin.show(
// //           _fgServiceNotificationId,
// //           'Data Backup',
// //           'Awesome ${DateTime.now()}',
// //           const NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               _channelId,
// //               _channelTitle,
// //               icon: 'ic_bg_service_small',
// //               ongoing: true,
// //               importance: Importance.high,
// //               priority: Priority.high,
// //             ),
// //           ),
// //         );
// //
// //         // Start listening shortly before needing the data
// //         stepService.startListening();
// //         await Future.delayed(const Duration(seconds: 5));  // Allow time to accumulate some steps
// //
// //         // int currentSteps = stepService.currentSteps;
// //         SharedPreferences preferences = await SharedPreferences.getInstance();
// //         List<String> timestamps = preferences.getStringList('timestamps') ?? [];
// //         String currentTimestamp = DateTime.now().toIso8601String();
// //         String stepCount = stepService.currentSteps.toString();
// //
// //         print("from onStart- $stepCount");
// //         String ip = '$stepCount at $currentTimestamp';
// //         timestamps.add(ip);
// //         await preferences.setStringList('timestamps', timestamps);
// //
// //         // if you don't using custom notification, uncomment this
// //
// //         // service.setForegroundNotificationInfo(
// //         //   title: "Siddharth Bg Service",
// //         //   content: "Updated at ${DateTime.now()}",
// //         // );
// //       }
// //     }
// //
// //     // Stop listening after the data is logged to conserve resources
// //     stepService.stopListening();
// //
// //     /// you can see this log in logcat
// //     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
// //
// //     // test using external plugin
// //     // final deviceInfo = DeviceInfoPlugin();
// //     // String? device;
// //     // if (Platform.isAndroid) {
// //     //   final androidInfo = await deviceInfo.androidInfo;
// //     //   device = androidInfo.model;
// //     // }
// //     //
// //     // if (Platform.isIOS) {
// //     //   final iosInfo = await deviceInfo.iosInfo;
// //     //   device = iosInfo.model;
// //     // }
// //
// //     // service.invoke(
// //     //   'update',
// //     //   {
// //     //     "current_date": DateTime.now().toIso8601String(),
// //     //     "device": device,
// //     //   },
// //     // );
// //   });
// // }
//
// // foreground_service.dart
//
//
// const String _channelId = 'fit_track_foreground';
// const String _channelTitle = 'FitTrack Foreground Service';
// const String _channelDescription = 'This channel is used for important notifications';
// const int _fgServiceNotificationId = 888;
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     _channelId,
//     _channelTitle,
//     description: _channelDescription,
//     importance: Importance.high,
//   );
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       iOS: DarwinInitializationSettings(),
//       android: AndroidInitializationSettings('ic_bg_service_small'),
//     ),
//   );
//
//   await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       autoStartOnBoot: true,
//       isForegroundMode: true,
//       notificationChannelId: _channelId,
//       initialNotificationTitle: _channelTitle,
//       initialNotificationContent: 'Running FitTrack App',
//       foregroundServiceNotificationId: _fgServiceNotificationId,
//     ),
//     iosConfiguration: IosConfiguration(),
//   );
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   final StepService stepService = StepService();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   stepService.startListening();
//
//   // Calculate the initial step count and save it immediately
//   await Future.delayed(const Duration(seconds: 15), () {
//     updateStepCounts(stepService.currentSteps);
//   });
//
//
//   Timer.periodic(const Duration(minutes: 16), (timer) async {
//     int steps = stepService.currentSteps;
//     await updateStepCounts(steps);
//
//     if (service is AndroidServiceInstance) {
//       // if (await service.isForegroundService())
//       // {
//         flutterLocalNotificationsPlugin.show(
//           _fgServiceNotificationId,
//           'FitTrack Service',
//           'Step count updated: ${steps} at ${DateTime.now()}',
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               _channelId,
//               _channelTitle,
//               icon: 'ic_bg_service_small',
//               ongoing: true,
//               importance: Importance.high,
//               priority: Priority.high,
//             ),
//           ),
//         );
//
//         // int currentSteps = stepService.currentSteps;
//         // SharedPreferences prefs = await SharedPreferences.getInstance();
//         // List<String> timestamps = prefs.getStringList('timestamps') ?? [];
//         // String ip = '${currentSteps} at ${DateTime.now().toIso8601String()}';
//         // timestamps.add(ip);
//         // await prefs.setStringList('timestamps', timestamps);
//       }
//     }
//   // }
// );
//
//   service.on('stopService').listen((event) => service.stopSelf());
// }
//
// //
// // UserHealthDataModel getHealthData(SharedPreferences prefs) {
// //   String? jsonString = prefs.getString('userHealthData');
// //   return jsonString != null ? userHealthDataModelFromJson(jsonString) : UserHealthDataModel();
// // }
//
// Future<void> updateStepCounts(int newStepCount) async {
//   print("newStepCount: $newStepCount");
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   DateTime now = DateTime.now();
//   // await prefs.reload();
//   String? jsonString = prefs.getString('userHealthData');
//   UserHealthDataModel healthData = jsonString != null ? userHealthDataModelFromJson(jsonString) : UserHealthDataModel();
//   if(jsonString == null){
//     healthData.absoluteStartStepCount = newStepCount;
//     healthData.todayStepCount = 0;
//     healthData.todayWalkTime = 0;
//     healthData.totalStepCount = 0;
//     healthData.totalWalkTime = 0;
//     healthData.stepCountRecordHourly = [];
//     healthData.stepCountRecordDaily = [];
//     healthData.lastUpdatedAt = now;
//   }
//
// else {
//   int absStartStepCount = healthData.absoluteStartStepCount??0;
//   if(newStepCount<absStartStepCount){
//     absStartStepCount = newStepCount;
//     healthData.absoluteStartStepCount = newStepCount;
//   }
//     // Check if a new day has started
//     bool isNewDay = healthData.lastUpdatedAt == null ||
//         now.day != healthData.lastUpdatedAt?.day;
//
//     if (isNewDay) {
//       // adding prev day step count record
//       healthData.stepCountRecordDaily ??= [];
//       if (healthData.lastUpdatedAt != null) {
//         int todayStepCount = healthData.todayStepCount ?? 0;
//         todayStepCount += newStepCount;
//         healthData.stepCountRecordDaily!.add(
//           ActivityRecord(
//               activityCount: todayStepCount.toString(), timestamp: now),
//         );
//       }
//       // Reset daily counts
//       healthData.todayStepCount = 0;
//       healthData.todayWalkTime = 0.0;
//       healthData.stepCountRecordHourly = [];
//     } else {
//       // Update hourly record
//       healthData.stepCountRecordHourly ??= [];
//       healthData.stepCountRecordHourly!.add(
//         ActivityRecord(activityCount: newStepCount.toString(), timestamp: now),
//       );
//       // Update daily count
//       int todayStepCount = healthData.todayStepCount ?? 0;
//       int totalStepCount = healthData.totalStepCount ?? 0;
//       todayStepCount += (newStepCount-absStartStepCount);
//       totalStepCount += (newStepCount-absStartStepCount);
//           healthData.todayStepCount = todayStepCount;
//           healthData.totalStepCount = totalStepCount;
//     }
//   }
//   prefs.setString('userHealthData', userHealthDataModelToJson(healthData));
// }
//
