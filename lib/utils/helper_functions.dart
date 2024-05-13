

double calculateDistance(double height, int steps) {
  double heightInMeters = height / 100.0;
  double stepLength = heightInMeters * 0.413;
  return (steps * stepLength)/1000; //km
}

double calculateCaloriesBurned(double weight, double distance) {
  return (0.57 * weight * distance); //kCal
}


String getMonthName(int month) {
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return months[month - 1];
}


String getCaloriesInTitle(double cal){
  if(cal>=130.0){
    return "${cal.toStringAsFixed(1)} kCal\ndone";
  }
  else{
    return "${(130-cal).toStringAsFixed(1)} kCal\n left";
  }
}

double getCaloriesValue(double calories){
  if(calories>=130) {
    return 100;
  }
  else{
    return (calories*100)/130.0;
  }
}

String getDistanceInTitle(double distance){
  if(distance>=2.0){
    return "${distance.toStringAsFixed(2)} km\ndone";
  }
  else{
    return "${(2.0-distance).toStringAsFixed(2)} km\n left";
  }
}

double getDistanceValue(double distance){
  if(distance>=2.0) {
    return 100;
  }
  else{
    return (distance*100)/2.0;
  }
}

double calculateBMI(double weightKg, double heightCm) {
  double heightM = heightCm / 100;
  double bmi = weightKg / (heightM * heightM);
  return bmi;
}

bool isPerfectWeight(double bmi) {
  return bmi >= 18.5 && bmi <= 24.9;
}

String getBMICategory(double bmi) {
  if (bmi < 18.5) {
    return 'Lower Weight';
  } else if (bmi >= 18.5 && bmi <= 24.9) {
    return 'Healthy Weight';
  } else if (bmi >= 25 && bmi <= 29.9) {
    return 'Overweight';
  } else {
    return 'Obese';
  }
}

double getWaterRatio(double waterIntake){
  if(waterIntake>5) {
    return 1.0;
  }
  return waterIntake/5.0;
}

double calculatePercent(int a, int b) {
  if (b == 0) {
    return 0.0;
  }
  if(a >= b){
    return 1.0;
  }
  double d = a/b;
  return d;
}

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}