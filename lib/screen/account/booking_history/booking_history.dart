import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class BookingHistory extends StatefulWidget {
  final int? ac;
  const BookingHistory({super.key, this.ac});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

int? _selectedIndex;

class _BookingHistoryState extends State<BookingHistory>
    with TickerProviderStateMixin {
  LocalStorage storageAuth = LocalStorage("auth");
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    if (widget.ac != null) {
      tabController?.animateTo(widget.ac!);
    } else {
      tabController?.addListener(_getActiveTabIndex);
    }
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void save() {
    setState(() {});
  }

  Future totalBooking(List list) async {
    List allService = [];
    num total = 0;
    final dio = Dio();
    for (var i = 0; i < list.length; i++) {
      final response = await dio.get(
          '$apiUrl/api/$idApp/dmvt?limit=100&q={"ten_vt":"${list[i]["ten_vt"]}","is_service":true,"status":true}&$token');
      for (var element in response.data) {
        allService.add(element["gia_ban_le"]);
      }
    }
    for (var i = 0; i < allService.length; i++) {
      total += allService[i];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          // bottomNavigationBar: const MyBottomMenu(
          //   active: 1,
          // ),
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
            title: const Text("Lịch sử đặt lịch",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          drawer: const MyLeftMenu(),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
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
                    });
                  },
                  tabs: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 45,
                      child: const Tab(
                        text: "Lịch sắp tới",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 45,
                      child: const Tab(
                        text: "Lịch đã hẹn",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 45,
                      child: const Tab(
                        text: "Lịch đã hủy",
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 180,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    if (storageAuth.getItem("phone") != null)
                      FutureBuilder(
                        future: callBookingApi1(storageAuth.getItem("phone")),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data!;
                            if (snapshot.data!.isNotEmpty) {
                              return RefreshIndicator(
                                onRefresh: refreshData,
                                child: ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: index != 0 ? 20 : 30,
                                          bottom: index == list.length - 1
                                              ? 20
                                              : 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(4,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      height: 135,
                                      child: FutureBuilder(
                                        future: callServiceApiById(
                                            list[index]["ten_vt"]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet<void>(
                                                      backgroundColor:
                                                          Colors.white,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.95,
                                                            child:
                                                                ModalChiTietBooking(
                                                              details:
                                                                  list[index],
                                                              details2: snapshot
                                                                  .data![0]!,
                                                              save: save,
                                                            ));
                                                      });
                                                },
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 12,
                                                              horizontal: 8)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Image.network(
                                                        "$apiUrl${snapshot.data![0]!["picture"]}?$token",
                                                        // width: 110,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Wrap(
                                                          children: [
                                                            Text(
                                                              "${snapshot.data![0]!["ten_vt"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            0,
                                                                        top: 5),
                                                                child: Html(
                                                                    style: {
                                                                      "*": Style(
                                                                          margin: Margins.only(
                                                                              top:
                                                                                  0,
                                                                              left:
                                                                                  0),
                                                                          maxLines:
                                                                              2,
                                                                          fontSize: FontSize(
                                                                              14),
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          textOverflow:
                                                                              TextOverflow.ellipsis),
                                                                    },
                                                                    data: snapshot
                                                                            .data![0]![
                                                                        "mieu_ta"])),
                                                            Text(
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          "vi_VI",
                                                                      symbol:
                                                                          "đ")
                                                                  .format(
                                                                snapshot.data![
                                                                        0]![
                                                                    "gia_ban_le"],
                                                              ),
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ))
                                                  ],
                                                ));
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Column(
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
                                      "Bạn chưa đặt lịch. Hãy đặt lịch ngày hôm nay để nhận được nhiều ưu đãi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    if (storageAuth.getItem("phone") != null)
                      FutureBuilder(
                        future: callBookingApi2(storageAuth.getItem("phone")),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data!;
                            if (snapshot.data!.isNotEmpty) {
                              return RefreshIndicator(
                                onRefresh: refreshData,
                                child: ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: index != 0 ? 20 : 30,
                                          bottom: index == list.length - 1
                                              ? 20
                                              : 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(4,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      height: 135,
                                      child: FutureBuilder(
                                        future: callServiceApiById(
                                            list[index]["ten_vt"]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet<void>(
                                                      backgroundColor:
                                                          Colors.white,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.95,
                                                            child:
                                                                ModalChiTietBooking(
                                                              details:
                                                                  list[index],
                                                              details2: snapshot
                                                                  .data![0]!,
                                                            ));
                                                      });
                                                },
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 12,
                                                              horizontal: 8)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Image.network(
                                                        "$apiUrl${snapshot.data![0]!["picture"]}?$token",
                                                        // width: 110,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Wrap(
                                                          children: [
                                                            Text(
                                                              "${snapshot.data![0]!["ten_vt"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            0,
                                                                        top: 5),
                                                                child: Html(
                                                                    style: {
                                                                      "*": Style(
                                                                          margin: Margins.only(
                                                                              top:
                                                                                  0,
                                                                              left:
                                                                                  0),
                                                                          maxLines:
                                                                              2,
                                                                          fontSize: FontSize(
                                                                              14),
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          textOverflow:
                                                                              TextOverflow.ellipsis),
                                                                    },
                                                                    data: snapshot
                                                                            .data![0]![
                                                                        "mieu_ta"])),
                                                            Text(
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          "vi_VI",
                                                                      symbol:
                                                                          "đ")
                                                                  .format(
                                                                snapshot.data![
                                                                        0]![
                                                                    "gia_ban_le"],
                                                              ),
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ))
                                                  ],
                                                ));
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Column(
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
                                      "Bạn chưa đặt lịch. Hãy đặt lịch ngày hôm nay để nhận được nhiều ưu đãi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    if (storageAuth.getItem("phone") != null)
                      FutureBuilder(
                        future: callBookingApi3(storageAuth.getItem("phone")),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data!;
                            if (snapshot.data!.isNotEmpty) {
                              return RefreshIndicator(
                                onRefresh: refreshData,
                                child: ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: index != 0 ? 20 : 30,
                                          bottom: index == list.length - 1
                                              ? 20
                                              : 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(4,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      height: 135,
                                      child: FutureBuilder(
                                        future: callServiceApiById(
                                            list[index]["ten_vt"]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet<void>(
                                                      backgroundColor:
                                                          Colors.white,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.95,
                                                            child:
                                                                ModalChiTietBooking(
                                                              details:
                                                                  list[index],
                                                              details2: snapshot
                                                                  .data![0]!,
                                                            ));
                                                      });
                                                },
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 12,
                                                              horizontal: 8)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Image.network(
                                                        "$apiUrl${snapshot.data![0]!["picture"]}?$token",
                                                        // width: 110,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Wrap(
                                                          children: [
                                                            Text(
                                                              "${snapshot.data![0]!["ten_vt"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            0,
                                                                        top: 5),
                                                                child: Html(
                                                                    style: {
                                                                      "*": Style(
                                                                          margin: Margins.only(
                                                                              top:
                                                                                  0,
                                                                              left:
                                                                                  0),
                                                                          maxLines:
                                                                              2,
                                                                          fontSize: FontSize(
                                                                              14),
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          textOverflow:
                                                                              TextOverflow.ellipsis),
                                                                    },
                                                                    data: snapshot
                                                                            .data![0]![
                                                                        "mieu_ta"])),
                                                            Text(
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          "vi_VI",
                                                                      symbol:
                                                                          "đ")
                                                                  .format(
                                                                snapshot.data![
                                                                        0]![
                                                                    "gia_ban_le"],
                                                              ),
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ))
                                                  ],
                                                ));
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Column(
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
                                      "Bạn chưa đặt lịch. Hãy đặt lịch ngày hôm nay để nhận được nhiều ưu đãi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
