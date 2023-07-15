import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_otp.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';

class ModalPhone extends StatefulWidget {
  const ModalPhone({super.key});

  @override
  State<ModalPhone> createState() => _ModalPhoneState();
}

String phoneNo = '';
String smsOTP = '';
String verificationID = '';
String errorMessage = '';
printMessage(String msg) {
  debugPrint(msg);
}

class _ModalPhoneState extends State<ModalPhone> {
  final LocalStorage storage = LocalStorage('auth');
  FirebaseAuth auth = FirebaseAuth.instance;
  void showAlertDialog(BuildContext context, String err) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            // height: 30,
            width: MediaQuery.of(context).size.width,
            child: Text(
              style: const TextStyle(height: 1.6),
              err,
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sendOTP(String phoneNumber) async {
      String phone = phoneNumber.replaceFirst(RegExp(r'0'), '+84');
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showAlertDialog(context, "Số điện thoại không hợp lệ");
          } else {
            // showAlertDialog(context, "$e");
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            verificationID = verificationId;
          });
        },
        timeout: const Duration(seconds: 20),
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verificationID = verificationId;
          });
        },
      );
    }

    void onLoading() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        sendOTP(phoneNo);
        Navigator.pop(context);
        showModalBottomSheet<void>(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                height: MediaQuery.of(context).size.height * 0.88,
                child: ModalOTP(phone: phoneNo, receivedID: verificationID),
              );
            });
        //pop dialog
      });
    }

    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(context),
                  intro(context),
                  TextField(
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    // controller: phoneNumber,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    onChanged: (value) {
                      setState(() {
                        phoneNo = value.toString();
                      });
                    },
                    // maxLength: 10,
                    autofocus: true,
                    decoration: InputDecoration(
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .primary), //<-- SEE HERE
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .primary), //<-- SEE HERE
                      ),
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.3),
                          fontWeight: FontWeight.w400),
                      hintText: 'Nhập số điện thoại...',
                    ),
                  ),
                  if (phoneNo.isNotEmpty && phoneNo.length < 10)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        'Số điện thoại phải có 10 chữ số',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                    )
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "home");
                        showModalBottomSheet<void>(
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
                                    MediaQuery.of(context).size.height * 0.96,
                                child: const ModalPassExist(),
                              );
                            });
                      },
                      child: const Text(
                        "Bạn đã có tài khoản",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  phoneNo.length == 10
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: TextButton(
                              onPressed: () {
                                onLoading();
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
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: const Text("Tiếp tục",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                        )
                ],
              ),
            ]));
  }
}

Widget header(BuildContext context) {
  return Row(
    children: [
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.keyboard_arrow_left_outlined,
          size: 30,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      const Text(
        "Quay lại",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      )
    ],
  );
}

Widget intro(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
    child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ngọc Hường xin chào!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Hãy nhập số điện thoại của bạn để tiếp tục nhé.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300))
        ]),
  );
}
