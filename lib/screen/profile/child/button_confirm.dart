import 'package:flutter/material.dart';

Widget buttonConfirm(BuildContext context, VoidCallback saveUserInfo) {
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(15.0))),
        child: TextButton(
            onPressed: saveUserInfo,
            style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.all(0.0))),
            child: const Text("Tiếp tục",
                style: TextStyle(fontSize: 16, color: Colors.white))),
      ));
}
