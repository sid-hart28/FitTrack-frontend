import 'package:fit_track/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';


class CountCard extends StatefulWidget {
  final double screenWidth;
  final String title;
  final String subTitle;
  final String inTitle;
  final double value;
  const CountCard({super.key,required this.screenWidth,
    required this.title,
    required this.subTitle,
    required this.inTitle,
    required this.value});

  @override
  State<CountCard> createState() => _CountCardState();
}

class _CountCardState extends State<CountCard> {
  late ValueNotifier<double> _progressNotifier;

  @override
  void initState() {
    super.initState();
    _progressNotifier = ValueNotifier(widget.value);
  }
  @override
  void didUpdateWidget(covariant CountCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _progressNotifier.value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = widget.screenWidth;
    return Container(
      width: double.maxFinite,
      height: screenWidth * 0.5,
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
            widget.title,
            style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
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
              widget.subTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: screenWidth * 0.21,
              height: screenWidth * 0.21,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.16,
                    height: screenWidth * 0.16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.075),
                    ),
                    child: FittedBox(
                      child: Text(
                        widget.inTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10),
                      ),
                    ),
                  ),
                  SimpleCircularProgressBar(
                    progressStrokeWidth: 10,
                    backStrokeWidth: 10,
                    progressColors: TColor.primaryG,
                    backColor: Colors.grey.shade100,
                    valueNotifier: _progressNotifier,
                    startAngle: 0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

