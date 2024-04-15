import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class MissionScreen extends StatefulWidget {
  final int? ac;
  const MissionScreen({super.key, this.ac});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

int? _selectedIndex;
List listAction = [
  {"Name": "Đang mở", "Value": "open"},
  {"Name": "Đang làm", "Value": "pending"},
  {"Name": "Hoàn thành", "Value": "Success"},
];

class _MissionScreenState extends State<MissionScreen>
    with TickerProviderStateMixin {
  final CheckInModel checkInModel = CheckInModel();
  final CustomModal customModal = CustomModal();
  final ScrollController scrollController = ScrollController();
  TabController? tabController;
  void _getActiveTabIndex() {
    setState(() {
      _selectedIndex = tabController!.index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
    tabController = TabController(length: listAction.length, vsync: this);
    if (widget.ac != null) {
      tabController?.animateTo(widget.ac!);
    } else {
      tabController?.addListener(_getActiveTabIndex);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  void nhannhiemvu(Map item) {
    EasyLoading.show(status: "Vui lòng chờ...");
    Future.delayed(const Duration(seconds: 2), () {
      checkInModel.collectMission(item["Id"]).then((value) {
        EasyLoading.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MissionScreen(
                      ac: 1,
                    )));
      });
    });
  }

  void nhanxu(Map item) {
    EasyLoading.show(status: "Vui lòng chờ...");
    Future.delayed(const Duration(seconds: 2), () {
      checkInModel.collectMission(item["Id"]).then((value) {
        EasyLoading.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MissionScreen(
                      ac: 2,
                    )));
      });
    });
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
              title: const Text("Nhiệm vụ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TabBar(
                          controller: tabController,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: "Quicksand"),
                          onTap: (tabIndex) {
                            setState(() {
                              _selectedIndex = tabIndex;
                            });
                          },
                          tabs: listAction
                              .map(
                                (item) => SizedBox(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      35,
                                  child: Tab(
                                    text: "${item["Name"]}",
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: listAction.map((i) {
                          return FutureBuilder(
                            future: checkInModel.getMissionByStatus(i["Value"]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List list = snapshot.data!.toList();
                                return list.isNotEmpty
                                    ? GestureDetector(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: list.map((e) {
                                            return GestureDetector(
                                                onTap: () {
                                                  if (e["Status"]
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "open") {
                                                    customModal.showAlertDialog(
                                                        context,
                                                        "error",
                                                        "Nhận nhiệm vụ",
                                                        "Bạn có chắc chắn nhận nhiệm vụ này",
                                                        () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      nhannhiemvu(e);
                                                    },
                                                        () => Navigator.pop(
                                                            context));
                                                  }
                                                  // else if (e["Status"]
                                                  //             .toString()
                                                  //             .toLowerCase() ==
                                                  //         "success" &&
                                                  //     e["IsReceived"] ==
                                                  //         false) {
                                                  //   Navigator.of(context).pop();
                                                  //   nhanxu(e);
                                                  // }
                                                },
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            left: 5,
                                                            right: 5),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0,
                                                            left: 10,
                                                            top: 0,
                                                            bottom: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 0.5,
                                                          color: mainColor),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  6)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              4,
                                                              4), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      e["Name"],
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      )),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                      e[
                                                                          "Description"],
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/icon/Xu1.png",
                                                                    width: 45,
                                                                    height: 45,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    "${e["Coin"]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color:
                                                                            mainColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        // if (e["Status"]
                                                        //         .toString()
                                                        //         .toLowerCase() ==
                                                        //     "success")
                                                        //   Text(
                                                        //       e["IsReceived"] ==
                                                        //               false
                                                        //           ? "Nhiệm vụ đã hoàn thành. Hãy ấn vào để nhận xu"
                                                        //           : "Đã nhận xu. Bạn hãy vào lịch sử nhận xu để kiểm tra",
                                                        //       style:
                                                        //           const TextStyle(
                                                        //         fontStyle:
                                                        //             FontStyle
                                                        //                 .italic,
                                                        //         fontSize: 10,
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w400,
                                                        //       ))
                                                      ],
                                                    )));
                                          }).toList(),
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(top: 40),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 40, bottom: 15),
                                              child: Image.asset(
                                                  "assets/images/account/img.webp"),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Text(
                                                "Chưa có nhiệm vụ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ));
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
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ))));
  }
}
