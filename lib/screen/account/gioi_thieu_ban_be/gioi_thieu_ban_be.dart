import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class GioiThieuBanBe extends StatefulWidget {
  const GioiThieuBanBe({super.key});

  @override
  State<GioiThieuBanBe> createState() => _GioiThieuBanBeState();
}

class _GioiThieuBanBeState extends State<GioiThieuBanBe> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            // bottomOpacity: 0.0,
            primary: false,
            elevation: 0.0,
            leadingWidth: 40,
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.west,
                size: 24,
                color: Colors.black,
              ),
            ),
            title: const Text("Giới thiệu bạn bè",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
          drawer: const MyLeftMenu(),
          body: SizedBox(
            child: Expanded(
              child: Column(
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
              ),
            ),
          )),
    );
  }
}
