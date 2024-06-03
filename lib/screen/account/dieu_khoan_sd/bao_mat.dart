import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/appInfoController.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class BaoMatScreen extends StatefulWidget {
  const BaoMatScreen({super.key});

  @override
  State<BaoMatScreen> createState() => _BaoMatScreenState();
}

class _BaoMatScreenState extends State<BaoMatScreen> {
  final AppInfoModel appInfoModel = AppInfoModel();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
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
            title: const Text("Chính sách bảo mật thông tin",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: Platform.isAndroid ? 75 : 100,
              child: const MyBottomMenu(
                active: 4,
              )),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: FutureBuilder(
                  future: appInfoModel.getAboutUs("policy2"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                          child: ListView(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 30),
                        children: [
                          snapshot.data!.isNotEmpty &&
                                  snapshot.data![0]["content"]
                                      .toString()
                                      .isNotEmpty
                              ? HtmlWidget(
                                  snapshot.data![0]["content"],
                                  // style: {
                                  //   "*": Style(
                                  //       fontSize: FontSize(15),
                                  //       margin: Margins.only(left: 0, right: 0),
                                  //       textAlign: TextAlign.justify),
                                  //   "p": Style(
                                  //       lineHeight: const LineHeight(1.8),
                                  //       fontSize: FontSize(15),
                                  //       fontWeight: FontWeight.w300,
                                  //       textAlign: TextAlign.justify),
                                  //   // "img": Style(margin: Margins.only(top: 5))
                                  //   //   "img": Style(
                                  //   //     width: Width(MediaQuery.of(context).size.width * .85),
                                  //   //     margin: Margins.only(top: 10, bottom: 6, left: 15, right: 0),
                                  //   //     textAlign: TextAlign.center
                                  //   //   )
                                  // },
                                )
                              : Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 40, bottom: 15),
                                      child: Image.asset(
                                          "assets/images/account/img.webp"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Text(
                                        'Chúng tôi đang cập nhật thông tin về Ngọc Hường Beauty',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      ));
                    } else {
                      return const Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: LoadingIndicator(
                                  colors: kDefaultRainbowColors,
                                  indicatorType: Indicator.lineSpinFadeLoader,
                                  strokeWidth: 1,
                                  // pathBackgroundColor: Colors.black45,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Đang lấy dữ liệu")
                            ]),
                      );
                    }
                  }))),
    );
  }
}
