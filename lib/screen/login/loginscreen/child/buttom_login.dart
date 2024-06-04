import 'package:flutter/material.dart';

Widget loginButton(BuildContext context, VoidCallback submit, bool loading) {
  return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              )),
              backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary.withOpacity(0.9)),
              shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))))),
          onPressed: submit,
          child: const Text(
            "Đăng nhập",
            style: TextStyle(color: Colors.white),
          )));
}
