import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

Widget inputOTP(
    BuildContext context,
    TextEditingController textEditingController,
    StreamController<ErrorAnimationType>? errorController,
    bool hasError,
    String currentText,
    GlobalKey<FormState> formKey,
    Function(String otp) loginWithOtp) {
  return Form(
    key: formKey,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 30,
      ),
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontWeight: FontWeight.w400,
        ),
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        length: 6,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        validator: (v) {
          if (v!.length < 3) {
            return "Nhập đầy đủ mã xác nhận";
          } else {
            return null;
          }
        },
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          selectedFillColor: Colors.grey.withOpacity(0.5),
          selectedColor: Colors.white,
          selectedBorderWidth: 1,
          activeColor: Colors.white,
          activeBorderWidth: 1,
          borderRadius: BorderRadius.circular(5),
          inactiveFillColor: Colors.grey.withOpacity(0.5),
          inactiveColor: Colors.white,
          fieldHeight: 45,
          fieldWidth: 40,
          activeFillColor: Colors.grey.withOpacity(0.5),
        ),
        cursorColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: textEditingController,
        keyboardType: TextInputType.number,
        boxShadows: const [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
        onCompleted: (v) async {
          debugPrint("Completed");
          loginWithOtp(v);
        },
        // onTap: () {
        //   print("Pressed");
        // },
        onChanged: (value) {},
        beforeTextPaste: (text) {
          debugPrint("Allowing to paste $text");
          return true;
        },
      ),
    ),
  );
}
