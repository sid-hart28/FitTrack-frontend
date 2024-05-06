//
// import 'dart:math';
//
// import 'package:fit_track/models/walking_history_model.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class WalkingHistoryChart extends StatefulWidget {
//   const WalkingHistoryChart({super.key});
//
//   @override
//   State<WalkingHistoryChart> createState() => _WalkingHistoryChartState();
// }
//
// List<WalkingHistory> walkingHistoryList = [];
//
// List<WalkingHistory> generateTestWalkingHistoryList(int count) {
//   Random random = Random();
//   List<WalkingHistory> list = [];
//
//   for (int i = 0; i < count; i++) {
//     int steps = random.nextInt(400);
//     double duration = random.nextDouble() * 120; // Random duration up to 120 minutes
//     DateTime timestamp = DateTime.now().add(Duration(days: -i));
//     list.add(WalkingHistory(
//       steps: steps,
//       duration: duration,
//       timestamp: timestamp,
//     ));
//   }
//
//   return list;
// }
//
// class _WalkingHistoryChartState extends State<WalkingHistoryChart> {
//   final List<int> showingTooltipOnSpots = [0];
//   int selectedSteps = walkingHistoryList.isNotEmpty ? walkingHistoryList[0].steps ?? 0 : 0;
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       walkingHistoryList = generateTestWalkingHistoryList(10);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context).size;
//     final lineBarsData = [
//       LineChartBarData(
//         showingIndicators: showingTooltipOnSpots,
//         spots: walkingHistoryList
//             .asMap()
//             .entries
//             .map((entry) => FlSpot(entry.key.toDouble(), entry.value.steps?.toDouble() ?? 0.0))
//             .toList(),
//         isCurved: false,
//         barWidth: 3,
//         belowBarData: BarAreaData(
//           show: true,
//           gradient: LinearGradient(
//               colors: [
//                 Colors.blue.withOpacity(0.4),
//                 Colors.blue.withOpacity(0.1),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter),
//         ),
//         dotData: const FlDotData(show: false),
//         gradient: LinearGradient(
//           colors: [Colors.blue, Colors.lightBlue],
//         ),
//       ),
//     ];
//
//     final tooltipsOnBar = lineBarsData[0];
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(15),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(25),
//               child: Container(
//                 height: media.width * 0.4,
//                 width: double.maxFinite,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Stack(
//                   alignment: Alignment.topLeft,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Walking History",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                           ShaderMask(
//                             blendMode: BlendMode.srcIn,
//                             shaderCallback: (bounds) {
//                               return LinearGradient(
//                                   colors: [Colors.blue, Colors.lightBlue],
//                                   begin: Alignment.centerLeft,
//                                   end: Alignment.centerRight)
//                                   .createShader(Rect.fromLTRB(
//                                   0, 0, bounds.width, bounds.height));
//                             },
//                             child: Text(
//                               "$selectedSteps steps",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 18),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     LineChart(
//                       LineChartData(
//                         showingTooltipIndicators:
//                         showingTooltipOnSpots.map((index) {
//                           return ShowingTooltipIndicators([
//                             LineBarSpot(
//                               tooltipsOnBar,
//                               lineBarsData.indexOf(tooltipsOnBar),
//                               tooltipsOnBar.spots[index],
//                             ),
//                           ]);
//                         }).toList(),
//                         lineTouchData: LineTouchData(
//                           enabled: true,
//                           handleBuiltInTouches: false,
//                           touchCallback: (FlTouchEvent event,
//                               LineTouchResponse? response) {
//                             if (response == null ||
//                                 response.lineBarSpots == null) {
//                               return;
//                             }
//                             if (event is FlTapUpEvent) {
//                               final spotIndex = response.lineBarSpots!.first.spotIndex;
//                               showingTooltipOnSpots.clear();
//                               setState(() {
//                                 showingTooltipOnSpots.add(spotIndex);
//                                 selectedSteps = walkingHistoryList[spotIndex].steps ?? 0;
//                               });
//                             }
//                           },
//                           mouseCursorResolver: (FlTouchEvent event,
//                               LineTouchResponse? response) {
//                             if (response == null || response.lineBarSpots == null) {
//                               return SystemMouseCursors.basic;
//                             }
//                             return SystemMouseCursors.click;
//                           },
//                           getTouchedSpotIndicator: (LineChartBarData barData,
//                               List<int> spotIndexes) {
//                             return spotIndexes.map((index) {
//                               return TouchedSpotIndicatorData(
//                                 const FlLine(
//                                   color: Colors.red,
//                                 ),
//                                 FlDotData(
//                                   show: true,
//                                   getDotPainter:
//                                       (spot, percent, barData, index) =>
//                                       FlDotCirclePainter(
//                                         radius: 3,
//                                         color: Colors.white,
//                                         strokeWidth: 3,
//                                         strokeColor: Colors.blue,
//                                       ),
//                                 ),
//                               );
//                             }).toList();
//                           },
//                           touchTooltipData: LineTouchTooltipData(
//                             tooltipRoundedRadius: 20,
//                             getTooltipItems:
//                                 (List<LineBarSpot> lineBarsSpot) {
//                               return lineBarsSpot.map((lineBarSpot) {
//                                 final timestamp = walkingHistoryList[lineBarSpot.x.toInt()].timestamp;
//                                 final formattedTimestamp = "${timestamp?.hour}:${timestamp?.minute}, ${timestamp?.day} ${_getMonthName(timestamp!.month)}";
//                                 return LineTooltipItem(
//                                   formattedTimestamp,
//                                   const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 );
//                               }).toList();
//                             },
//                           ),
//                         ),
//                         lineBarsData: lineBarsData,
//                         minY: 0,
//                         maxY: 500,
//                         titlesData: const FlTitlesData(show: false),
//                         gridData: const FlGridData(show: false),
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border.all(color: Colors.transparent),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getMonthName(int month) {
//     List<String> months = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec"
//     ];
//     return months[month - 1];
//   }
// }