import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/login/modal_Info.dart';
import 'package:ngoc_huong/screen/login/modal_otp.dart';

class ModalPass extends StatefulWidget {
  const ModalPass({super.key});

  @override
  State<ModalPass> createState() => _ModalPassState();
}

String password = "";
String confirmPassword = "";
bool showPass = false;
bool showConfirm = false;
bool check = true;

class _ModalPassState extends State<ModalPass> {
  final LocalStorage storage = LocalStorage('auth');
  @override
  void initState() {
    setState(() {
      password = "";
      confirmPassword = "";
      showPass = false;
      showConfirm = false;
      check = true;
    });
    super.initState();
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
                  intro(context, storage),
                  SizedBox(
                    height: storage.getItem("typeOTP") == null ? 270 : 250,
                    child: Expanded(
                      child: ListView(
                        children: [
                          Text(
                              storage.getItem("typeOTP") == null
                                  ? "Tạo mật khẩu"
                                  : "Mật khẩu mới",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
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
                            autofocus: true,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey), //<-- SEE HERE
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
                            keyboardType: TextInputType.number,
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
                            autofocus: true,
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary), //<-- SEE HERE
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey), //<-- SEE HERE
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
                          if (storage.getItem("typeOTP") == null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color:
                                          check ? Colors.green : Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: check
                                              ? Colors.green
                                              : Colors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          check = !check;
                                        });
                                      },
                                      child: check == true
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                          : null),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Bằng việc tiếp tục, bạn xác nhận đã đọc và",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Colors.black.withOpacity(0.7))),
                                    Row(
                                      children: [
                                        Text("đồng ý với",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black
                                                    .withOpacity(0.7))),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: const Text(
                                              "Điều khoản và sử dụng",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              password.length >= 6 &&
                      confirmPassword.length >= 6 &&
                      password == confirmPassword &&
                      check == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0))),
                      child: TextButton(
                          onPressed: () {
                            if (storage.getItem("typeOTP") == null) {
                              storage.setItem('pass', password);
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
                                          MediaQuery.of(context).size.height *
                                              0.96,
                                      child: const ModalInfo(),
                                    );
                                  });
                            } else {
                              Navigator.canPop(context);
                            }
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0.0))),
                          child: Text(
                              storage.getItem("typeOTP") == null
                                  ? "Tiếp tục"
                                  : "Hoàn thành",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white))),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0))),
                      child: Text(
                          storage.getItem("typeOTP") == null
                              ? "Tiếp tục"
                              : "Hoàn thành",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black)),
                    )
            ]));
  }
}

Widget intro(
  BuildContext context,
  LocalStorage storage,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            storage.getItem("typeOTP") == null
                ? "Mật khẩu đăng nhập"
                : "Khôi phục mật khẩu",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: storage.getItem("typeOTP") == null ? 10 : 30,
          ),
          if (storage.getItem("typeOTP") == null)
            const Text("Mật khẩu giúp tài khoản của bạn bảo mật và an toàn hơn",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300))
        ]),
  );
}
