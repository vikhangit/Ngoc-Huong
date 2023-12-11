import 'package:flutter/material.dart';

class BeautyProfile extends StatefulWidget {
  const BeautyProfile({super.key});

  @override
  State<BeautyProfile> createState() => _BeautyProfileState();
}

class _BeautyProfileState extends State<BeautyProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40, bottom: 15),
          child: Image.asset("assets/images/account/img.webp"),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text(
            "Chưa có đơn hàng",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
        )
      ],
    );
  }
}
