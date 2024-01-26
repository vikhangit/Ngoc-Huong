import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:upgrader/upgrader.dart';

class GioiThieuBanBe extends StatefulWidget {
  const GioiThieuBanBe({super.key});

  @override
  State<GioiThieuBanBe> createState() => _GioiThieuBanBeState();
}

class _GioiThieuBanBeState extends State<GioiThieuBanBe> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      bottom: false, top: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.west,
                    size: 16,
                    color: Colors.black,
                  ),
                )),
            title: const Text("Giới thiệu bạn bè",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          bottomNavigationBar: const MyBottomMenu(active: 4),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40, bottom: 15),
                    child: Image.asset("assets/images/account/img.webp"),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Bạn chưa có lượt giới thiệu bạn bè. Đừng quên "Giới Thiệu Bạn Bè" để cùng nhận được nhiều ưu đãi hấp dẫn',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ))),
    );
  }
}
