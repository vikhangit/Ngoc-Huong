import 'package:flutter/material.dart';

Widget introOTP(BuildContext context, String p) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(top: 5, bottom: 40),
    child: Column(children: [
      const Text(
        "Xác thực OTP",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      ),
      const SizedBox(
        height: 10,
      ),
      Text("Mã xác thực đã gửi đến số điện thoại",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.5))),
      Text(p,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
    ]),
  );
}
