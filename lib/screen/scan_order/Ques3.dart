import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class Ques3 extends StatefulWidget {
  final String question;
  const Ques3({super.key, required this.question});

  @override
  State<Ques3> createState() => _Ques3State();
}

double valueRating3 = 1.0;

class _Ques3State extends State<Ques3> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      valueRating3 = 1.0;
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
                value: valueRating3,
                onValueChanged: (v) {
                  setState(() {
                    valueRating3 = v;
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
                    child: valueRating3.round() >= index1 + 1
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
