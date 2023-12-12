import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/screen/account/buy_history/beauty_profile.dart';
import 'package:ngoc_huong/screen/account/buy_history/modal_chi_tiet_buy.dart';
import 'package:ngoc_huong/screen/account/buy_history/order_history.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class BuyHistory extends StatefulWidget {
  final List listTab;
  final int? ac;
  const BuyHistory({super.key, this.ac, required this.listTab});

  @override
  State<BuyHistory> createState() => _BuyHistoryState();
}

int? selectedIndex;
int selectedParent = 0;
int length = 0;
String activeTab = "";
List status = [];
List typeHistory = [
  {"id": 1, "title": "Hồ sơ làm đẹp"},
  {"id": 2, "title": "Lịch sử hóa đơn"},
  {"id": 3, "title": "Lịch sử tích lũy điểm"},
  {"id": 4, "title": "Lịch sử voucher"},
  {"id": 5, "title": "Lịch sử tích bảo hành"},
];

class _BuyHistoryState extends State<BuyHistory> with TickerProviderStateMixin {
  TabController? tabController;
  TabController? tabController1;
  final OrderModel orderModel = OrderModel();
  final ScrollController scrollController = ScrollController();
  void _getActiveParentTabIndex() {
    setState(() {
      selectedParent = tabController1!.index;
    });
  }

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    tabController1 = TabController(length: typeHistory.length, vsync: this);
    tabController1?.addListener(_getActiveParentTabIndex);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void save() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: 100,
              child: const MyBottomMenu(
                active: 4,
              )),
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
            title: const Text("Lịch sử mua hàng",
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
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      controller: tabController1,
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Colors.transparent,
                      labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "Quicksand",
                          color: Theme.of(context).colorScheme.primary),
                      onTap: (tabIndex) {
                        setState(() {
                          selectedParent = tabIndex;
                        });
                      },
                      tabs: typeHistory.map((e) {
                        int index = typeHistory.indexOf(e);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: selectedParent == index
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8)
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          // width:
                          //     MediaQuery.of(context).size.width / 2 - 40,
                          child: Tab(
                            text: "${e["title"]}",
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: MediaQuery.of(context).size.height - 320,
                      child: TabBarView(controller: tabController1, children: [
                        const BeautyProfile(),
                        OrderHistory(
                          listTab: widget.listTab,
                          ac: widget.ac,
                        ),
                        OrderHistory(
                          listTab: widget.listTab,
                          ac: widget.ac,
                        ),
                        OrderHistory(
                          listTab: widget.listTab,
                          ac: widget.ac,
                        ),
                        const BeautyProfile()
                      ]))
                ],
              ))),
    );
  }
}
