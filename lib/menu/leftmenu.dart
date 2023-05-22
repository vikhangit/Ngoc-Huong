import 'package:flutter/material.dart';

class MyLeftMenu extends StatefulWidget {
  const MyLeftMenu({super.key});

  @override
  State<MyLeftMenu> createState() => _MyLeftMenuState();
}

class _MyLeftMenuState extends State<MyLeftMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          TextButton(onPressed: () {}, child: const Text("Header")),
          TextButton(onPressed: () {}, child: const Text("Content")),
          TextButton(onPressed: () {}, child: const Text("Footer"))
        ]));
  }
}
