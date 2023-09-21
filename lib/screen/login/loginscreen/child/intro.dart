import 'package:flutter/material.dart';

Widget introLogin(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "Chào bạn !!!",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
          ),
        ),
        Text(
          "Vui lòng nhập số điện thoại để trải nghiệm những dịch vụ tuyệt vời",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.6)),
        ),
      ],
    ),
  );
}
