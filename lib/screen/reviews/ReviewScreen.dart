import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/screen/ModalPlayVideo.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final NewsModel newsModel = NewsModel();
  final BannerModel bannerModel = BannerModel();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: Platform.isAndroid ? 75 : 100,
                child: const MyBottomMenu(
                  active: 0,
                )),
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
              title: const Text("NGỌC HƯỜNG BEAUTY - GÓP Ý DỊCH VỤ",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: SingleChildScrollView(
                    // reverse: true,
                    controller: scrollController,
                    child: Container(
                        margin: const EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 15),
                        child: SizedBox(
                          child: FutureBuilder(
                            future: bannerModel.getReviewServices(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List list = snapshot.data!.toList();
                                if (list.isEmpty) {
                                  return Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 0, bottom: 10),
                                        child: Image.asset(
                                            "assets/images/account/img.webp"),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 40),
                                        child: const Text(
                                          "Xin lỗi! Hiện tại Ngọc Hường chưa có thông tin review",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Wrap(
                                    spacing: 15,
                                    runSpacing: 15,
                                    children: list.map((item) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModalPlayVideo(
                                                          item: item,
                                                          url:
                                                              "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4")));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              22.5,
                                          padding: const EdgeInsets.only(
                                              left: 6,
                                              right: 6,
                                              bottom: 10,
                                              top: 6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 130,
                                                  child: HtmlWidget(
                                                    item["content"],
                                                    customStylesBuilder:
                                                        (element) {
                                                      if (element.localName ==
                                                          "iframe") {
                                                        return {
                                                          "width": "100%",
                                                          "height": "100%"
                                                        };
                                                      }
                                                    },
                                                  )),
                                              Text(
                                                "${item["title"]}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    height: 1.2,
                                                    color: mainColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                              } else {
                                return const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: LoadingIndicator(
                                        colors: kDefaultRainbowColors,
                                        indicatorType:
                                            Indicator.lineSpinFadeLoader,
                                        strokeWidth: 1,
                                        // pathBackgroundColor: Colors.black45,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Đang lấy dữ liệu")
                                  ],
                                );
                              }
                            },
                          ),
                        ))))));
  }
}
