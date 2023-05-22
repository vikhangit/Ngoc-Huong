import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/login/modal_pass.dart';

class ModalOTP extends StatefulWidget {
  final String phone;
  const ModalOTP({super.key, required this.phone});

  @override
  State<ModalOTP> createState() => _ModalOTPState();
}

String otp = '';
String val1 = '';
String val2 = '';
String val3 = '';
String val4 = '';

int seconds = 59;
bool isRunning = false;
Timer? _timer;

class _ModalOTPState extends State<ModalOTP> {
  @override
  void initState() {
    setState(() {
      val1 = '';
      val2 = '';
      val3 = '';
      val4 = '';
    });
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header(context),
                  intro(context, widget.phone.toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextField(
                          style: const TextStyle(
                              height: 1.2, color: Colors.black, fontSize: 24.0),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                          onChanged: (value) {
                            setState(() {
                              val1 = value;
                            });
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          style: const TextStyle(
                              height: 1.2, color: Colors.black, fontSize: 24.0),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                          onChanged: (value) {
                            setState(() {
                              val2 = value;
                            });
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          style: const TextStyle(
                              height: 1.2, color: Colors.black, fontSize: 24.0),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                          onChanged: (value) {
                            setState(() {
                              val3 = value;
                            });
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          style: const TextStyle(
                              height: 1.2, color: Colors.black, fontSize: 24.0),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                              hintStyle: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                          onChanged: (value) {
                            setState(() {
                              val4 = value;
                            });
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  seconds == 0
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              seconds = 59;
                            });
                            _startTimer();
                          },
                          child: Text(
                            "Gửi lại mã OTP",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.blue.withOpacity(0.99)),
                          ),
                        )
                      : Text(
                          "Gửi lại mã OTP sau 00:${seconds < 10 ? '0$seconds' : seconds}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  val1.isNotEmpty &&
                          val2.isNotEmpty &&
                          val3.isNotEmpty &&
                          val4.isNotEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0))),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  otp = val1 + val2 + val3 + val4;
                                });
                                showModalBottomSheet<void>(
                                    backgroundColor: Colors.white,
                                    // shape: const RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.vertical(
                                    //     top: Radius.circular(15.0),
                                    //   ),
                                    // ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.96,
                                        child: const ModalPass(),
                                      );
                                    });
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0.0))),
                              child: const Text("Tiếp tục",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white))),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0))),
                          child: const Text("Tiếp tục",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                        )
                ],
              )
            ]));
  }
}

Widget header(BuildContext context) {
  return Container(
    alignment: Alignment.centerRight,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(
        Icons.close,
        size: 24,
      ),
    ),
  );
}

Widget intro(BuildContext context, String p) {
  return Container(
    margin: const EdgeInsets.only(top: 5, bottom: 40),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Xác thực OTP",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text("Nhập mã 4 số được gữi đến",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
              Text(" $p",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500))
            ],
          )
        ]),
  );
}

Widget otpInput(
    BuildContext context, bool autoFocus, TextEditingController controller) {
  return SizedBox(
    height: 60,
    width: 50,
    child: TextField(
      autofocus: autoFocus,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: controller,
      maxLength: 1,
      cursorColor: Theme.of(context).primaryColor,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          counterText: '',
          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
      onChanged: (value) {
        if (value.length == 1) {
          FocusScope.of(context).nextFocus();
        } else {
          FocusScope.of(context).previousFocus();
        }
      },
    ),
  );
}
