import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:fit_track/models/user_health_history_model.dart';

class DailyActivityView extends StatelessWidget {
  final List<Daily> stepCountDaily;
  final List<Daily> walkTimeDaily;

  const DailyActivityView({super.key,
    required this.stepCountDaily,
    required this.walkTimeDaily,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Activity")),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Daily Steps Count',
              style: TextStyle(fontSize: 16),),
          ),
          const SizedBox(height: 20,),
          _buildBarChart("Daily Step Count", stepCountDaily, int.parse),
          const SizedBox(height: 30,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Daily Walk Time',
    style: TextStyle(fontSize: 16),),
          ),
          const SizedBox(height: 20,),
          _buildBarChart("Daily Walk Time", walkTimeDaily, double.parse),
        ],
      ),
    );
  }

  Widget _buildBarChart(String title, List<Daily> data, Function parseFunction) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
            barGroups: data
                .asMap()
                .entries
                .map((entry) =>
                BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: parseFunction(entry.value.activityCount ?? '0')
                          .toDouble(),
                      color: Colors.blue,
                      width: 20,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ))
                .toList(),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final DateTime date = data[value.toInt()].timestamp!;
                    final String formattedDate =
                    DateFormat.MMMd().format(date);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50, // Increase reserved size to avoid overflow
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4,
                      child: Text(
                        value.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}