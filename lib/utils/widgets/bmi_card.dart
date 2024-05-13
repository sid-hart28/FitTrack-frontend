import 'package:fit_track/utils/colors.dart';
import 'package:fit_track/utils/helper_functions.dart';
import 'package:flutter/material.dart';


class BMICard extends StatelessWidget {
  const BMICard({
    super.key,
    required this.screenWidth,
    required this.bmi,
  });

  final double bmi;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: screenWidth * 0.5,
      padding: const EdgeInsets.symmetric(
          vertical: 15, horizontal: 20),
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
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                  colors: TColor.primaryG,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)
                  .createShader(Rect.fromLTRB(
                  0, 0, bounds.width, bounds.height));
            },
            child: Text(
              "BMI",
              style: TextStyle(
                  color: TColor.white.withOpacity(0.9),
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth * 0.3,
              height: screenWidth * 0.3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: TColor.primaryG),
                borderRadius: BorderRadius.circular(
                    screenWidth * 0.075),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(bmi.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                  Icon(isPerfectWeight(bmi)?
                  Icons.check_circle_rounded:
                  Icons.warning_amber,
                    size: 40,),
                  Text(getBMICategory(bmi))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}