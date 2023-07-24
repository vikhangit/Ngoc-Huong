import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';

class ModalChangePass extends StatefulWidget {
  const ModalChangePass({super.key});

  @override
  State<ModalChangePass> createState() => _ModalChangePassState();
}

String oldPass = "";
String password = "";
String confirmPassword = "";
bool showOldPass = false;
bool showPass = false;
bool showConfirm = false;

class _ModalChangePassState extends State<ModalChangePass> {
  LocalStorage storageAuth = LocalStorage('auth');
  LocalStorage storageToken = LocalStorage('token');
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
  void dispose() {
    oldPass = "";
    password = "";
    confirmPassword = "";
    showPass = false;
    showConfirm = false;
    showOldPass = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void changePasword() async {
      Map data = {
        "oldPassword": oldPass,
        "newPassword": password,
        "reNewPassword": confirmPassword
      };
      final dio = Dio();
      try {
        final response = await dio
            .post(
                "https://api.fostech.vn/api/changepassword?access_token=${storageToken.getItem("token")}",
                data: data)
            .then((value) {
          Navigator.pushNamed(context, "home");
          storageAuth.deleteItem("phone");
          setState(() {
            ElegantNotification.success(
              width: MediaQuery.of(context).size.width,
              height: 50,
              notificationPosition: NotificationPosition.topCenter,
              toastDuration: const Duration(milliseconds: 2000),
              animation: AnimationType.fromTop,
              // title: const Text('Cập nhật'),
              description: const Text(
                'Đổi mật khẩu thành công',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              onDismiss: () {},
            ).show(context);
          });
        });
      } on DioException catch (e) {
        Navigator.pop(context);
        showAlertDialog(context, "${e.response!.data["error"]}");
      }
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
        changePasword();

        Navigator.pop(context);
      });
    }

    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    intro(context),
                    const Text("Mật khẩu hiện tại",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      onChanged: (value) {
                        setState(() {
                          oldPass = value.toString();
                        });
                      },
                      obscureText: !showOldPass,
                      enableSuggestions: false,
                      autocorrect: false,

                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showOldPass = !showOldPass;
                            });
                          },
                          icon: showOldPass == false
                              ? const Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                        ),
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
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey), //<-- SEE HERE
                        ),
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.3),
                            fontWeight: FontWeight.w400),
                        hintText: '••••••',
                      ),
                    ),
                    if (oldPass.isNotEmpty && oldPass.length < 6)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Mật khẩu cần ít nhất 6 số",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w300)),
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Mật khẩu mới",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      onChanged: (value) {
                        setState(() {
                          password = value.toString();
                        });
                      },
                      obscureText: !showPass,
                      enableSuggestions: false,
                      autocorrect: false,

                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          icon: showPass == false
                              ? const Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                        ),
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
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey), //<-- SEE HERE
                        ),
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.3),
                            fontWeight: FontWeight.w400),
                        hintText: '••••••',
                      ),
                    ),
                    if (password.isNotEmpty && password.length < 6)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Mật khẩu cần ít nhất 6 số",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w300)),
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Xác nhận mật khẩu",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value.toString();
                        });
                      },
                      obscureText: !showConfirm,
                      enableSuggestions: false,
                      autocorrect: false,

                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showConfirm = !showConfirm;
                              });
                            },
                            icon: showConfirm == false
                                ? const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                          ),
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
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey), //<-- SEE HERE
                          ),
                          hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.3),
                              fontWeight: FontWeight.w400),
                          hintText: '••••••'),
                    ),
                    if (confirmPassword.length >= 6 &&
                        confirmPassword != password)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Xác nhận mật khẩu không đúng",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w300)),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              oldPass.length >= 6 &&
                      password.length >= 6 &&
                      confirmPassword.length >= 6 &&
                      password == confirmPassword
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: TextButton(
                          onPressed: () {
                            AlertDialog alert = AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  return SizedBox(
                                      // height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            size: 70,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text(
                                            "Đổi mật khẩu",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Bạn có chắc chắn đổi mật khẩu không?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      ));
                                },
                              ),
                              actionsPadding: const EdgeInsets.only(
                                  top: 0, left: 30, right: 30, bottom: 30),
                              actions: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextButton(
                                    onPressed: () => onLoading(),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15)),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                    child: const Text(
                                      "Đồng ý",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 15)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              side: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1))),
                                    ),
                                    child: const Text("Hủy bỏ"),
                                  ),
                                )
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
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0.0))),
                          child: const Text("Xác nhận",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white))),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: const Text("Xác nhận",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    )
            ]));
  }
}

Widget intro(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
    child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Đổi mật khẩu",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
        ]),
  );
}
