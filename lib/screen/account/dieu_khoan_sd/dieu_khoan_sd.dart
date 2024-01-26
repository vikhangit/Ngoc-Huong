import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/screen/account/dieu_khoan_sd/bao_hanh.dart';
import 'package:ngoc_huong/screen/account/dieu_khoan_sd/bao_mat.dart';
import 'package:ngoc_huong/screen/account/dieu_khoan_sd/van_chuyen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:upgrader/upgrader.dart';

class DieuKhoanSudung extends StatefulWidget {
  const DieuKhoanSudung({super.key});

  @override
  State<DieuKhoanSudung> createState() => _DieuKhoanSudungState();
}

class _DieuKhoanSudungState extends State<DieuKhoanSudung> {
  CustomModal customModal = CustomModal();
  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
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
            title: const Text("Điều khoản sử dụng",
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
            child: SizedBox(
              child: ListView(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BaoHanhScreen()));
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chính sách bảo hành",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BaoMatScreen()));
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chính sách bảo mật thông tin",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VanChuyenScreen()));
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chính sách vận chuyển và giao hàng",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
