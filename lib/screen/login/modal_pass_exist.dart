import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalPassExist extends StatefulWidget {
  const ModalPassExist({super.key});

  @override
  State<ModalPassExist> createState() => _ModalPassExistState();
}

String username = "";
String password = "";
bool showPass = false;
bool err = false;

class _ModalPassExistState extends State<ModalPassExist> {
  final LocalStorage storageAuth = LocalStorage('auth');
  final LocalStorage storageToken = LocalStorage('token');
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
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    username = "";
    password = "";
    showPass = false;
    err = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void loginAccount() async {
      final dio = Dio();
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username:$password'));
      try {
        final response = await dio.get(
            "$apiUrl/auth/local?group_id=$groupId&id_app=$idApp",
            options:
                Options(headers: <String, String>{'authorization': basicAuth}));
        print(response);
        await storageToken.setItem("token", response.data["token"].toString());
        await storageAuth.setItem("phone", username);
        await storageAuth.setItem("existAccount", "true");
        storageToken.dispose();
        storageAuth.dispose();
        Navigator.pop(context);
      } on DioException catch (e) {
        showAlertDialog(context, "${e.response!.data["message"]}");
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
        Navigator.pop(context);
        loginAccount();
      });
    }

    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    intro(context),
                    const Text("Số điện thoại",
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
                          username = value.toString();
                        });
                      },
                      decoration: InputDecoration(
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
                        hintText: 'Nhập số điện thoại',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Nhập mật khẩu",
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
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: InkWell(
                        onTap: () {
                          showAlertDialog(context,
                              "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
                        },
                        child: const Text(
                          "Quên mật khẩu",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        storage.deleteItem("typeOTP");
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
                                child: const ModalPhone(),
                              );
                            });
                      },
                      child: const Text(
                        "Đăng ký bằng số điện thoại khác",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  password.length >= 6 && username.isNotEmpty
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
                                      fontSize: 14, color: Colors.white))),
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

Widget intro(
  BuildContext context,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
        ]),
  );
}
