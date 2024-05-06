import 'package:fit_track/models/user_health_data_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestingView extends StatefulWidget {
  const TestingView({super.key});

  @override
  State<TestingView> createState() => _TestingViewState();
}

class _TestingViewState extends State<TestingView> {
  // UserHealthDataModel userHealthDataModel=UserHealthDataModel();
  String toShow = "";
  void getList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    String? jsonString = prefs.getString('userHealthData');
    UserHealthDataModel healthData = jsonString != null ? userHealthDataModelFromJson(jsonString) : UserHealthDataModel();
    // List<String>? timestamps = prefs.getStringList('timestamps') ?? [];
    setState(() {
      // userHealthDataModel = healthData;
      toShow = userHealthDataModelToJson(healthData);
    });
    print(healthData);
  }

  @override
  void initState() {
    getList();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
          Center(child: Text(toShow),),
      // ListView(
      //   children: myList.map((str) => Text(str, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)).toList(),
      // ),
      ),
    );
  }
}


