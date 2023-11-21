import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/choose_brand/chooseBrand.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

Widget bannerLogin(BuildContext context) {
  final LocalStorage storageBranch = LocalStorage("branch");
  final LocalStorage storageStart = LocalStorage("start");
  return Container(
    height: MediaQuery.of(context).size.height - 325,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(right: 15, top: 10),
    alignment: Alignment.topRight,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage("assets/images/login/banner.jpg"),
          fit: BoxFit.cover,
        )),
    child: GestureDetector(
      onTap: () {
        if (storageStart.getItem("start") != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          storageStart.deleteItem("start");
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.white)),
        child: Text(
          "Bỏ qua",
          style: TextStyle(
              color: mainColor, fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );
}
