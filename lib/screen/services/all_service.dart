import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';

class AllServiceScreen extends StatefulWidget {
  final List listTab;
  const AllServiceScreen({super.key, required this.listTab});

  @override
  State<AllServiceScreen> createState() => _AllServiceScreenState();
}

int _selectedIndex = 0;
bool isLoading = false;
String showIndex = "";

class _AllServiceScreenState extends State<AllServiceScreen>
    with TickerProviderStateMixin {
  final ServicesModel servicesModel = ServicesModel();
  final LocalStorage storageToken = LocalStorage("customer_token");
  TabController? tabController;
  void _getActiveTabIndex() {
    setState(() {
      _selectedIndex = tabController!.index;
      isLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _selectedIndex = 0;
      showIndex = "";
    });
    tabController = TabController(length: widget.listTab.length, vsync: this);
    tabController?.addListener(
      () {
        _getActiveTabIndex();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
    showIndex = "";
    _selectedIndex = 0;
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: const MyBottomMenu(active: 0),
      appBar: AppBar(
        primary: false,
        elevation: 0.0,
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
        title: const Text("Dịch vụ",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: TabBar(
                controller: tabController,
                isScrollable: true,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.black,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "LexendDeca"),
                onTap: (tabIndex) {
                  setState(() {
                    _selectedIndex = tabIndex;
                    isLoading = true;
                  });
                  Future.delayed(
                    const Duration(seconds: 2),
                    () {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  );
                },
                tabs: widget.listTab
                    .map((e) => Tab(
                          text: e["GroupName"],
                        ))
                    .toList()),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              height: MediaQuery.of(context).size.height - 310,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: TabBarView(
                controller: tabController,
                children: widget.listTab.map((item) {
                  return FutureBuilder(
                    future: servicesModel.getServiceByGroup(
                        widget.listTab[_selectedIndex]["GroupCode"]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List list = snapshot.data!.toList();
                        return ListView(children: [
                          Wrap(
                              runSpacing: 15,
                              alignment: WrapAlignment.spaceBetween,
                              children: list.map((item) {
                                return GestureDetector(
                                    onTap: () => setState(() {
                                          showIndex = item["Code"];
                                        }),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              22.5,
                                          height: 230,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6)),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 1)),
                                          child: isLoading
                                              ? const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: LoadingIndicator(
                                                        colors:
                                                            kDefaultRainbowColors,
                                                        indicatorType: Indicator
                                                            .lineSpinFadeLoader,
                                                        strokeWidth: 1,
                                                        // pathBackgroundColor: Colors.black45,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.network(
                                                          // "${item["Image_Name"]}"
                                                          "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                                          fit: BoxFit.cover,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 120,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "${item["Name"]}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width,
                                                      child: TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              showIndex =
                                                              item[
                                                              "Code"];
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all(Theme.of(
                                                                  context)
                                                                  .colorScheme
                                                                  .primary)),
                                                          child: const Text(
                                                              "Xem thêm",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  color: Colors
                                                                      .white))),
                                                    )
                                                  ],
                                                ),
                                        ),
                                        if (showIndex.isNotEmpty &&
                                            showIndex == item["Code"])
                                          Positioned.fill(
                                              child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  6)),
                                                      color: Colors.black
                                                          .withOpacity(0.4)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              showIndex = "";
                                                            });
                                                            showModalBottomSheet<
                                                                    void>(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom: MediaQuery.of(context)
                                                                              .viewInsets
                                                                              .bottom),
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.95,
                                                                      child:
                                                                          ChiTietScreen(
                                                                        detail:
                                                                            item,
                                                                      ));
                                                                });
                                                          },
                                                          child: Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 6,
                                                                  horizontal:
                                                                      10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .blue[500],
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            4)),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                      "assets/images/eye-white.png",
                                                                      width: 24,
                                                                      height:
                                                                          24),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  const Text(
                                                                    "Xem chi tiết",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  )
                                                                ],
                                                              ))),
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              showIndex = "";
                                                            });
                                                            if (storageToken
                                                                    .getItem(
                                                                        "customer_token") ==
                                                                null) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const LoginScreen()));
                                                            } else {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          BookingServices(
                                                                            dichvudachon:
                                                                                item,
                                                                          )));
                                                            }
                                                          },
                                                          child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 6,
                                                                  horizontal:
                                                                      10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  color: Colors
                                                                          .blue[
                                                                      900]),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                      "assets/images/calendar-solid-white.png",
                                                                      width: 24,
                                                                      height:
                                                                          24),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  const Text(
                                                                    "Đặt lịch",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  )
                                                                ],
                                                              )))
                                                    ],
                                                  )))
                                      ],
                                    ));
                              }).toList())
                        ]);
                      } else {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                          ],
                        );
                      }
                    },
                  );
                }).toList(),
              ))
        ],
      ),
    ));
  }
}
