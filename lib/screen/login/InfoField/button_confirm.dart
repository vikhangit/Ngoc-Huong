import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/login/modal_Info.dart';

Widget buttonConfirm(BuildContext context, Function saveUserInfo) {
  return SizedBox(
      child: firstname.isNotEmpty &&
              lastname.isNotEmpty &&
              birthDay.isNotEmpty &&
              email.isNotEmpty
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0))),
              child: TextButton(
                  onPressed: () {
                    saveUserInfo();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0.0))),
                  child: const Text("Tiếp tục",
                      style: TextStyle(fontSize: 16, color: Colors.white))),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0))),
              child: const Text("Tiếp tục",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ));
}
