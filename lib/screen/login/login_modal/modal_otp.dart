import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/loginModel.dart';
import 'package:ngoc_huong/screen/login/login_modal/child/headerOtp.dart';
import 'package:ngoc_huong/screen/login/login_modal/child/inputOtp.dart';
import 'package:ngoc_huong/screen/login/login_modal/child/introOtp.dart';
import 'package:ngoc_huong/screen/login/login_modal/child/resendOtp.dart';
import 'package:ngoc_huong/screen/profile/profile_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ModalOTP extends StatefulWidget {
  final String phone;
  const ModalOTP({super.key, required this.phone});

  @override
  State<ModalOTP> createState() => _ModalOTPState();
}

int seconds = 30;
bool isRunning = false;
Timer? _timer;

class _ModalOTPState extends State<ModalOTP> {
  TextEditingController textEditingController = TextEditingController();
  final LocalStorage storageStart = LocalStorage("start");
  StreamController<ErrorAnimationType>? errorController;
  final Login login = Login();
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _startTimer();
    errorController = StreamController<ErrorAnimationType>();
    setState(() {
      seconds = 30;
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    errorController!.close();
    seconds = 30;
    textEditingController.dispose();
    super.dispose();
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        setState(() {
          _timer?.cancel();
        });
      }
    });
  }

  void resend() {
    login.getOtp(widget.phone).then((value) {
      setState(() {
        seconds = 29;
        textEditingController = TextEditingController(text: "");
      });
      _startTimer();
    });
  }

  void checkLogin(String otp) {
    EasyLoading.show(
      status: 'Đăng nhập...',
      maskType: EasyLoadingMaskType.black,
    );
    login.setLogin(context, widget.phone.toString(), otp).then((value) {
      EasyLoading.dismiss();

      storageStart.deleteItem("start");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(children: [
          headerOTP(context),
          introOTP(context, widget.phone.toString()),
          const Text("Nhập mã OTP để tiếp tục",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
          const SizedBox(
            height: 6,
          ),
          inputOTP(context, textEditingController, errorController, hasError,
              currentText, formKey, (otp) => checkLogin(otp)),
          resendOTP(seconds, resend)
        ]));
  }
}
