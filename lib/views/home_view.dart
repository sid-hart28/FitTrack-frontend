import 'dart:ui';

import 'package:fit_track/models/user_health_history_model.dart';
import 'package:fit_track/models/user_profile_model.dart';
import 'package:fit_track/models/walking_history_model.dart';
import 'package:fit_track/utils/helper_functions.dart';
import 'package:fit_track/services/step_service.dart';
import 'package:fit_track/utils/utils.dart';
import 'package:fit_track/utils/widgets/bmi_card.dart';
import 'package:fit_track/utils/widgets/count_card.dart';
import 'package:fit_track/views/daily_activity_view.dart';
import 'package:fit_track/views/walking_tracker_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'dart:async';

import '../../utils/colors.dart';
import '../../utils/widgets/round_button.dart';
import '../../utils/widgets/workout_row.dart';
import 'finished_workout_view.dart';
import 'notification_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

final StepService _stepService = StepService();
List<WalkingHistory> walkingHistoryList = [];

class _HomeViewState extends State<HomeView> {
  UserHealthHistoryModel? userHealthHistory;

  @override
  void initState() {
    super.initState();
    _loadUserHealthHistory();
    _loadWalkingHistory();
  }

  // @override
  // void didUpdateWidget(covariant HomeView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if(widget!=oldWidget){
  //     _loadWalkingHistory();
  //   }
  // }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    await _loadWalkingHistory();
    await _loadUserHealthHistory();
  }


  Future<void> _loadWalkingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    print('in loadWalking');
    final historyJson = prefs.getString('walkingHistoryModel');
    if (historyJson != null) {
      WalkingHistoryModel model = walkingHistoryModelFromJson(historyJson);
      setState(() {
        walkingHistoryList = model.walkingHistoryList ?? [];
        print('done inloading');
      });
    }
  }


  Future<void> _addWaterIntake(double waterAmount) async {
    setState(() {
      userHealthHistory!.todayWaterIntake = (userHealthHistory!.todayWaterIntake ?? 0.0) + waterAmount;
      userHealthHistory!.lastTimestamp = DateTime.now();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userHealthHistoryModel', userHealthHistoryModelToJson(userHealthHistory!));
  }

  Future<void> _loadUserHealthHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    String? userHealthHistoryJson = prefs.getString('userHealthHistoryModel');
    if (userHealthHistoryJson != null) {
      setState(() {
        userHealthHistory = userHealthHistoryModelFromJson(userHealthHistoryJson);
      });
    } else {
      setState(() {
        userHealthHistory = UserHealthHistoryModel(
          todayStepCount: 0,
          todayWalkTime: 0.0,
          todayCalorie: 0.0,
          todayWaterIntake: 0.0,
          stepCountDaily: [],
          walkTimeDaily: [],
        );
      });
    }
  }

  final List<int> showingTooltipOnSpots = [1];

  int selectedSteps = walkingHistoryList.isNotEmpty ? walkingHistoryList[1].steps ?? 0 : 0;



  @override
  Widget build(BuildContext context) {
    final userProfile = ModalRoute.of(context)!.settings.arguments as UserProfile;
    var media = MediaQuery.of(context).size;
    int steps = userHealthHistory?.todayStepCount ?? 0;
    double waterIntake = userHealthHistory?.todayWaterIntake ?? 0.0;
    double calories = userHealthHistory?.todayCalorie ?? 0.0;
    double height = userProfile.height ?? 175;
    double weight = userProfile.weight ?? 65;
    double distance = calculateDistance(height, steps);

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: walkingHistoryList.isEmpty
            ? [const FlSpot(0, 0), const FlSpot(1, 0)]  // Only show initial and final spots if list is empty
            : [
          const FlSpot(0, 0),  // Initial zero spot
          ...walkingHistoryList.asMap().entries.map(
                  (entry) => FlSpot(
                entry.key.toDouble() + 1,  // Offset by 1 for the initial zero spot
                entry.value.steps?.toDouble() ?? 0.0,
              )
          ),
          FlSpot(walkingHistoryList.length.toDouble() + 1, 0)  // Final zero spot
        ],
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.4),
              Colors.blue.withOpacity(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        dotData: FlDotData(
          show: true,
          checkToShowDot: (FlSpot spot, LineChartBarData barData) {
            int index = barData.spots.indexOf(spot);
            // Do not show dots for the first and last artificial points
            return index != 0 && index != barData.spots.length - 1;
          },
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 3,
            color: Colors.white,
            strokeWidth: 3,
            strokeColor: Colors.blue,
          ),
        ),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue],
        ),
      ),
    ];


    final tooltipsOnBar = lineBarsData[0];



    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                        Text(
                          userProfile.name!,
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      await Navigator.pushReplacementNamed(context, '/login');
                    },
                      icon:
                      Icon(Icons.logout),),

                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationView(),
                            ),
                          );
                        },
                        icon: Image.asset(
                          "assets/img/notification_active.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.fitHeight,
                        ))
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  height: media.width * 0.42,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG2),
                      borderRadius: BorderRadius.circular(media.width * 0.075)),
                  child: Stack(alignment: Alignment.center, children: [
                    Image.asset(
                      "assets/img/bg_dots.png",
                      height: media.width * 0.4,
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Steps Count",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Keep going",
                                style: TextStyle(
                                    color: TColor.white.withOpacity(0.7),
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              SizedBox(
                                width: 120,
                                height: 35,
                                child: RoundButton(
                                    title: "Start Walking",
                                    type: RoundButtonType.bgSGradient,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    onPressed: () async{
                                      Route route = MaterialPageRoute(builder: (context) => WalkingTrackerView(userProfile: userProfile));
                                      Navigator.push(context, route);
                                      //     .then((value) {
                                      //   _loadWalkingHistory();
                                      // });
                                      print('Back from tracker, reloading history');
                                      // await _loadWalkingHistory();
                                      // await printWalkingHistoryList();
                                    }),
                              )
                            ],
                          ),
                          CircularPercentIndicator(
                            radius: media.width*0.13,
                            lineWidth: 13.0,
                            animation: true,
                            percent: calculatePercent(steps, 5000),
                            center: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                    colors: [Colors.blueAccent, Colors.black87],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)
                                    .createShader(Rect.fromLTRB(
                                    0, 0, bounds.width, bounds.height));
                              },
                              child: Text(
                                "${(calculatePercent(steps, 5000) * 100).toStringAsFixed(1)}%",
                                style:
                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                            ),
                            footer: Text(
                              "$steps / 5000",
                              style:
                             const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor:TColor.secondaryColor1,
                            backgroundColor: Colors.white54,
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CountCard(screenWidth: media.width,
                        title: 'Calories',
                        subTitle: "${calories.toStringAsFixed(2)} kCal",
                        inTitle: getCaloriesInTitle(calories),
                        value: getCaloriesValue(calories),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: CountCard(screenWidth: media.width,
                        title: 'Distance covered',
                        subTitle: '${distance.toStringAsFixed(2)} km',
                        inTitle: getDistanceInTitle(distance),
                        value: getDistanceValue(distance),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: TColor.primaryColor2.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily Activity",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 70,
                        height: 25,
                        child: RoundButton(
                          title: "Check",
                          type: RoundButtonType.bgGradient,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                               DailyActivityView(
                                    stepCountDaily: userHealthHistory?.stepCountDaily??[],
                                    walkTimeDaily: userHealthHistory?.walkTimeDaily??[],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Activity Status",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.5,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Walking History",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                      colors: [Colors.black87, Colors.lightBlue],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)
                                      .createShader(Rect.fromLTRB(
                                      0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "$selectedSteps steps",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: LineChart(
                            LineChartData(
                              showingTooltipIndicators: walkingHistoryList.isEmpty
                                  ? []
                                  : showingTooltipOnSpots.map((index) {
                                return ShowingTooltipIndicators([
                                  LineBarSpot(
                                    tooltipsOnBar,
                                    lineBarsData.indexOf(tooltipsOnBar),
                                    tooltipsOnBar.spots[index],
                                  ),
                                ]);
                              }).toList(),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                handleBuiltInTouches: false,
                                touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                                  if (response == null || response.lineBarSpots == null || event is! FlTapUpEvent || response.lineBarSpots!.isEmpty) {
                                    return;
                                  }
                                  final spotIndex = response.lineBarSpots!.first.spotIndex;
                                  // Ensure we don't process touches on the artificial zero-value spots
                                  if (spotIndex == 0 || spotIndex == walkingHistoryList.length + 1) {
                                    return;
                                  }
                                  setState(() {
                                    showingTooltipOnSpots.clear();
                                    showingTooltipOnSpots.add(spotIndex);
                                    selectedSteps = walkingHistoryList[spotIndex - 1].steps ?? 0; // Adjust for zero at start
                                  });
                                },
                                mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
                                  if (response == null || response.lineBarSpots == null) {
                                    return SystemMouseCursors.basic;
                                  }
                                  return SystemMouseCursors.click;
                                },
                                getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                                  return spotIndexes.map((index) {
                                    if (index == 0 || index == walkingHistoryList.length + 1) {
                                      return const TouchedSpotIndicatorData(
                                        FlLine(color: Colors.transparent),
                                        FlDotData(show: false),
                                      );
                                    }
                                    return TouchedSpotIndicatorData(
                                      const FlLine(color: Color(0xffC58BF2)),
                                      FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 4.5,
                                              color: Colors.pinkAccent.shade200,
                                              strokeWidth: 4.5,
                                              strokeColor: Colors.blue,
                                            ),
                                      ),
                                    );
                                  }).toList();
                                },
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipRoundedRadius: 20,
                                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                                    return lineBarsSpot.map((lineBarSpot) {
                                      // Skip tooltip for the first and last artificial spots
                                      if (lineBarSpot.x == 0 || lineBarSpot.x == walkingHistoryList.length + 1) {
                                        return null;
                                      }
                                      final index = lineBarSpot.x.toInt() - 1; // Adjust index for the extra spot at the beginning
                                      final timestamp = walkingHistoryList[index].timestamp;
                                      final formattedTimestamp = '${timestamp?.hour}:${timestamp?.minute}, ${timestamp?.day} ${getMonthName(timestamp!.month)}';
                                      return LineTooltipItem(
                                        '${lineBarSpot.y.toInt()} steps\n$formattedTimestamp',
                                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      );
                                    }).toList();
                                  },

                                ),
                              ),
                              lineBarsData: lineBarsData,
                              minY: 0,
                              maxY: getMaxY(),
                              titlesData: const FlTitlesData(show: false),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: true, border: Border.all(color: Colors.transparent)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: media.width * 0.95,
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 2)
                            ]),
                        child: Row(
                          children: [
                            SimpleAnimationProgressBar(
                              height: media.width * 0.85,
                              width: media.width * 0.07,
                              backgroundColor: Colors.grey.shade100,
                              foregrondColor: Colors.purple,
                              ratio: getWaterRatio(waterIntake),
                              direction: Axis.vertical,
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(seconds: 3),
                              borderRadius: BorderRadius.circular(15),
                              gradientColor: LinearGradient(
                                  colors: TColor.primaryG,
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Water Intake",
                                        style: TextStyle(
                                            color: TColor.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) {
                                          return LinearGradient(
                                              colors: TColor.primaryG,
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)
                                              .createShader(Rect.fromLTRB(0, 0,
                                              bounds.width, bounds.height));
                                        },
                                        child: Text(
                                          "$waterIntake Liters",
                                          style: TextStyle(
                                              color: TColor.white.withOpacity(0.7),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Remember to be hydrated.",
                                        style: TextStyle(
                                          color: TColor.gray,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 100,),
                                      RoundButton(title: '+250\nml', onPressed: () async{
                                        await _addWaterIntake(0.25);
                                      })
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.05,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>
                                const  FinishedWorkoutView(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: media.width * 0.4,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 2)
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sleep",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                            colors: TColor.primaryG,
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)
                                            .createShader(Rect.fromLTRB(0, 0,
                                            bounds.width, bounds.height));
                                      },
                                      child: Text(
                                        "8h 20m",
                                        style: TextStyle(
                                            color: TColor.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),
                                    // const Spacer(),
                                    Expanded(
                                      child: Image.asset(
                                          "assets/img/sleep_grap.png",
                                          width: double.maxFinite,
                                          fit: BoxFit.fitWidth),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          BMICard(screenWidth: media.width, bmi: calculateBMI(weight, height)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Workout",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "See More",
                        style: TextStyle(
                            color: TColor.gray,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lastWorkoutArr.length,
                    itemBuilder: (context, index) {
                      var wObj = lastWorkoutArr[index] as Map? ?? {};
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const FinishedWorkoutView(),
                              ),
                            );
                          },
                          child: WorkoutRow(wObj: wObj));
                    }),
                SizedBox(
                  height: media.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double getMaxY(){
  if (walkingHistoryList.isEmpty) {
    return 100;
  }
  int maxSteps = 0;
  for (var history in walkingHistoryList) {
    if (history.steps != null && history.steps! > maxSteps) {
      maxSteps = history.steps!;
    }
  }
  double ms = maxSteps == 0 ? 100 : maxSteps.toDouble();
  return ms *1.25;
}

