import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class TranHistory extends StatefulWidget {
  const TranHistory({super.key});

  @override
  State<TranHistory> createState() => _MyWidgetState();
}

int? _selectedIndex;

class _MyWidgetState extends State<TranHistory> with TickerProviderStateMixin {
  TabController? tabController;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
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
          body: SizedBox(
              child: Column(
            children: [
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: mainColor.withOpacity(0.3),
                  child: Theme(
                    data: ThemeData().copyWith(splashColor: mainColor),
                    child: TabBar(
                      controller: tabController,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                      unselectedLabelColor: Colors.black.withOpacity(0.4),
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
                          width: MediaQuery.of(context).size.width / 2,
                          child: const Tab(
                            text: "Đã nhận",
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
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
                    // Container(
                    //   margin: const EdgeInsets.only(top: 40),
                    //   child: Image.asset("assets/images/account/img.webp"),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.only(top: 40),
                    //   child: Image.asset("assets/images/account/img.webp"),
                    // )
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tháng 1/2024",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: List.generate(8, (index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    margin: EdgeInsets.only(
                                        top: index != 0 ? 5 : 0),
                                    decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ngày 16/1/2024",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "Điểm danh nhận 10 xu",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tháng 12/2023",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: List.generate(8, (index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    margin: EdgeInsets.only(
                                        top: index != 0 ? 5 : 0),
                                    decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ngày 16/1/2024",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "Điểm danh nhận 10 xu",
                                          style: TextStyle(fontSize: 12),
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
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tháng 1/2024",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: List.generate(8, (index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    margin: EdgeInsets.only(
                                        top: index != 0 ? 5 : 0),
                                    decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ngày 16/1/2024",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "Điểm danh nhận 10 xu",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tháng 12/2023",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: List.generate(8, (index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    margin: EdgeInsets.only(
                                        top: index != 0 ? 5 : 0),
                                    decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ngày 16/1/2024",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "Điểm danh nhận 10 xu",
                                          style: TextStyle(fontSize: 12),
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
                    )
                  ],
                ),
              )
            ],
          ))),
    );
  }
}
