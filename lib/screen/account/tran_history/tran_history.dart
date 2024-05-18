import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class TranHistory extends StatefulWidget {
  const TranHistory({super.key});

  @override
  State<TranHistory> createState() => _MyWidgetState();
}

List receiptHistory = [];
List usageHistory = [];
bool loading = true;

int? _selectedIndex;

class _MyWidgetState extends State<TranHistory> with TickerProviderStateMixin {
  TabController? tabController;
  final ScrollController scrollController = ScrollController();
  final CheckInModel checkInModel = CheckInModel();
  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    checkInModel
        .getReceiptHistory()
        .then((value) => setState(() => receiptHistory = value));
    checkInModel
        .getUsageHistory()
        .then((value) => setState(() => usageHistory = value));
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        loading = false;
      });
    });
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
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
                active: 4,
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
            title: const Text("Lịch sử giao dịch xu",
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
              child: loading
                  ? const Center(
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
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                            color: mainColor.withOpacity(0.3),
                            child: Theme(
                              data:
                                  ThemeData().copyWith(splashColor: mainColor),
                              child: TabBar(
                                controller: tabController,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                unselectedLabelColor:
                                    Colors.black.withOpacity(0.4),
                                labelColor: Colors.black,
                                indicatorColor: mainColor,
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    fontFamily: "Quicksand"),
                                onTap: (tabIndex) {
                                  setState(() {
                                    _selectedIndex = tabIndex;
                                  });
                                },
                                tabs: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: const Tab(
                                      text: "Đã nhận",
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: const Tab(
                                      text: "Đã dùng",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    receiptHistory.isEmpty
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 40),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 40, bottom: 15),
                                                  child: Image.asset(
                                                      "assets/images/account/img.webp"),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: const Text(
                                                    "Chưa có lịch sử",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                )
                                              ],
                                            ))
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: List.generate(
                                                    receiptHistory.length,
                                                    (index) {
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                    margin: EdgeInsets.only(
                                                        top:
                                                            index != 0 ? 5 : 0),
                                                    decoration: BoxDecoration(
                                                        color: mainColor
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                                  "dd/MM/yyyy")
                                                              .format(DateTime.parse(
                                                                  receiptHistory[
                                                                          index]
                                                                      [
                                                                      "CreatedDate"])),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                        Text(
                                                          "${receiptHistory[index]["Type"] == "DailyReport" ? "Điểm danh" : receiptHistory[index]["Type"] == "Mission" ? "Làm nhiêmhj vụ" : ""}  nhận ${receiptHistory[index]["Coin"]} xu",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    usageHistory.isEmpty
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 40),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 40, bottom: 15),
                                                  child: Image.asset(
                                                      "assets/images/account/img.webp"),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: const Text(
                                                    "Chưa có lịch sử",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                )
                                              ],
                                            ))
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: List.generate(
                                                    usageHistory.length,
                                                    (index) {
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                    margin: EdgeInsets.only(
                                                        top:
                                                            index != 0 ? 5 : 0),
                                                    decoration: BoxDecoration(
                                                        color: mainColor
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                                  "dd/MM/yyyy")
                                                              .format(DateTime.parse(
                                                                  usageHistory[
                                                                          index]
                                                                      [
                                                                      "CreatedDate"])),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                        Text(
                                                          "${usageHistory[index]["Type"] == "Expiry" ? "Hết hạn trừ ${usageHistory[index]["Coin"]} xu" : "Mua hàng dùng ${usageHistory[index]["Coin"]} xu"} ",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))),
    );
  }
}
