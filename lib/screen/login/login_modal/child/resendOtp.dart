import 'package:flutter/material.dart';

Widget resendOTP(int seconds, Function resend) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Không nhận được mã? ",
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 13,
        ),
      ),
      seconds == 0
          ? GestureDetector(
              onTap: () {
                resend();
              },
              child: Text(
                "Gửi lại",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.blue.withOpacity(0.99)),
              ),
            )
          : Row(
              children: [
                Text(
                  "Gửi lại ",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.6)),
                ),
                Text(
                  "(${seconds < 10 ? '0$seconds' : seconds}s)",
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ],
            )
    ],
  );
}
