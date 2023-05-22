import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_otp.dart';

class ModalPhone extends StatefulWidget {
  const ModalPhone({super.key});

  @override
  State<ModalPhone> createState() => _ModalPhoneState();
}

String phone = "";

class _ModalPhoneState extends State<ModalPhone> {
  final LocalStorage storage = LocalStorage('auth');
  @override
  void initState() {
    setState(() {
      phone = "";
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
                  header(context),
                  intro(context),
                  TextField(
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    onChanged: (value) {
                      setState(() {
                        phone = value.toString();
                      });
                    },
                    maxLength: 10,
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
                  if (phone.isNotEmpty && phone.length < 10)
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
              phone.length == 10
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0))),
                      child: TextButton(
                          onPressed: () {
                            storage.setItem("phone", phone);
                            // storage.deleteItem("typeOTP");
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
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    height: MediaQuery.of(context).size.height *
                                        0.88,
                                    child: ModalOTP(phone: phone),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0))),
                      child: const Text("Tiếp tục",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    )
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
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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
