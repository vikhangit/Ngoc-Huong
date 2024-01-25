import 'package:flutter/material.dart';

Widget headerOTP(BuildContext context) {
  return Container(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const Icon(
        Icons.close,
        size: 24,
      ),
    ),
  );
}
