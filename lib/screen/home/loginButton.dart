import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/utils/callapi.dart';

Widget buttonLogin(BuildContext context) {
  LocalStorage storageAuth = LocalStorage("auth");

  return GestureDetector(
    onTap: () {
      showModalBottomSheet<void>(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            ),
          ),
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).size.height * 0.96,
              child: const ModalPassExist(),
            );
          });
    },
    child: Container(
      decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Row(
        children: [
          Image.asset(
            width: 35,
            height: 35,
            "assets/images/account.png",
          ),
          const Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          )
        ],
      ),
    ),
  );
}
