import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class Ques2 extends StatefulWidget {
  final String question;
  const Ques2({super.key, required this.question});

  @override
  State<Ques2> createState() => _Ques2State();
}

double valueRating2 = 1.0;

class _Ques2State extends State<Ques2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      valueRating2 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(widget.question),
            ),
            Center(
              child: RatingStars(
                value: valueRating2,
                onValueChanged: (v) {
                  setState(() {
                    valueRating2 = v;
                  });
                },
                starCount: 5,
                starSize: 24,
                maxValue: 5,
                starSpacing: 5,
                maxValueVisibility: true,
                valueLabelVisibility: false,
                animationDuration: const Duration(milliseconds: 1000),
                starBuilder: (index1, color) {
                  return SizedBox(
                    child: valueRating2.round() >= index1 + 1
                        ? Image.asset(
                            "assets/images/star-solid.png",
                            width: 28,
                            height: 28,
                          )
                        : Image.asset("assets/images/star-outline.png",
                            width: 28, height: 28),
                  );
                },
                starOffColor: mainColor,
                starColor: mainColor,
              ),
            )
          ],
        ));
  }
}
