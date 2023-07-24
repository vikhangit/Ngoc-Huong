import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/account/buy_history/modal_chi_tiet_buy.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class BuyHistory extends StatefulWidget {
  final int? ac;
  const BuyHistory({super.key, this.ac});

  @override
  State<BuyHistory> createState() => _BuyHistoryState();
}

int? _selectedIndex;

class _BuyHistoryState extends State<BuyHistory> with TickerProviderStateMixin {
  LocalStorage storageAuth = LocalStorage("auth");
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);

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
            title: const Text("Lịch sử mua hàng",
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
                      width: MediaQuery.of(context).size.width / 3 - 15,
                      child: const Tab(
                        text: "Chờ xác nhận",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 15,
                      child: const Tab(
                        text: "Đã xác nhận",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 15,
                      child: const Tab(
                        text: "Đang giao",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 15,
                      child: const Tab(
                        text: "Đã giao",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 15,
                      child: const Tab(
                        text: "Đã hủy",
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (storageAuth.getItem("phone") != null)
                          FutureBuilder(
                            future: getProfile(storageAuth.getItem("phone")),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List profile = snapshot.data!;
                                return FutureBuilder(
                                  future: callPBLApiStatus(
                                      profile[0]["ma_kh"], "0"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isNotEmpty) {
                                        List list = snapshot.data!;
                                        return Expanded(
                                            child: RefreshIndicator(
                                          onRefresh: refreshData,
                                          child: ListView.builder(
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: index != 0 ? 20 : 30,
                                                      bottom: index ==
                                                              list.length - 1
                                                          ? 20
                                                          : 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 8,
                                                        offset: const Offset(4,
                                                            4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  // height: 135,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ModalChiTietBuy(
                                                                          product:
                                                                              list[index],
                                                                          type:
                                                                              "",
                                                                          save:
                                                                              save,
                                                                        )));
                                                      },
                                                      style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all(const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 8)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shape: MaterialStateProperty.all(
                                                            const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)))),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                child: Image
                                                                    .network(
                                                                  "$apiUrl${list[index]["details"][0]!["picture"]}?$token",
                                                                  // width: 110,
                                                                  height: 60,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                        "${list[index]["details"][0]["ten_vt"]}",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${list[index]["details"][0]["sl_xuat"]}",
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          const Text(
                                                                              "x"),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(
                                                                              list[index]["details"][0]["gia_ban_le_goc"],
                                                                            ),
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.primary),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                border: BorderDirectional(
                                                                    top: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors.grey[
                                                                            400]!),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey[400]!))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${list[index]["t_sl_order"]} sản phẩm",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Thành tiền:",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                              locale:
                                                                                  "vi_VI",
                                                                              symbol:
                                                                                  "đ")
                                                                          .format(list[index]
                                                                              [
                                                                              "t_tien"]),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            },
                                          ),
                                        ));
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
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Text(
                                                "Chưa có đơn hàng",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (storageAuth.getItem("phone") != null)
                          FutureBuilder(
                            future: getProfile(storageAuth.getItem("phone")),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List profile = snapshot.data!;
                                return FutureBuilder(
                                  future: callPBLApiStatus(
                                      profile[0]["ma_kh"], "1"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isNotEmpty) {
                                        List list = snapshot.data!;
                                        return Expanded(
                                            child: RefreshIndicator(
                                          onRefresh: refreshData,
                                          child: ListView.builder(
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: index != 0 ? 20 : 30,
                                                      bottom: index ==
                                                              list.length - 1
                                                          ? 20
                                                          : 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 8,
                                                        offset: const Offset(4,
                                                            4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  // height: 135,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ModalChiTietBuy(
                                                                          product:
                                                                              list[index],
                                                                          type:
                                                                              "xác nhận",
                                                                        )));
                                                      },
                                                      style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all(const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 8)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shape: MaterialStateProperty.all(
                                                            const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)))),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                child: Image
                                                                    .network(
                                                                  "$apiUrl${list[index]["details"][0]!["picture"]}?$token",
                                                                  // width: 110,
                                                                  height: 60,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                        "${list[index]["details"][0]["ten_vt"]}",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${list[index]["details"][0]["sl_xuat"]}",
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          const Text(
                                                                              "x"),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(
                                                                              list[index]["details"][0]["gia_ban_le_goc"],
                                                                            ),
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.primary),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                border: BorderDirectional(
                                                                    top: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors.grey[
                                                                            400]!),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey[400]!))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${list[index]["t_sl_order"]} sản phẩm",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Thành tiền:",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                              locale:
                                                                                  "vi_VI",
                                                                              symbol:
                                                                                  "đ")
                                                                          .format(list[index]
                                                                              [
                                                                              "t_tien"]),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            },
                                          ),
                                        ));
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
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Text(
                                                "Chưa có đơn hàng",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (storageAuth.getItem("phone") != null)
                          FutureBuilder(
                            future: getProfile(storageAuth.getItem("phone")),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List profile = snapshot.data!;
                                return FutureBuilder(
                                  future: callPBLApiStatus(
                                      profile[0]["ma_kh"], "3"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isNotEmpty) {
                                        List list = snapshot.data!;
                                        return Expanded(
                                            child: RefreshIndicator(
                                          onRefresh: refreshData,
                                          child: ListView.builder(
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: index != 0 ? 20 : 30,
                                                      bottom: index ==
                                                              list.length - 1
                                                          ? 20
                                                          : 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 8,
                                                        offset: const Offset(4,
                                                            4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  // height: 135,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ModalChiTietBuy(
                                                                          product:
                                                                              list[index],
                                                                          type:
                                                                              "vận chuyển",
                                                                        )));
                                                      },
                                                      style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all(const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 8)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shape: MaterialStateProperty.all(
                                                            const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)))),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                child: Image
                                                                    .network(
                                                                  "$apiUrl${list[index]["details"][0]!["picture"]}?$token",
                                                                  // width: 110,
                                                                  height: 60,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                        "${list[index]["details"][0]["ten_vt"]}",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${list[index]["details"][0]["sl_xuat"]}",
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          const Text(
                                                                              "x"),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(
                                                                              list[index]["details"][0]["gia_ban_le_goc"],
                                                                            ),
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.primary),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                border: BorderDirectional(
                                                                    top: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors.grey[
                                                                            400]!),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey[400]!))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${list[index]["t_sl_order"]} sản phẩm",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Thành tiền:",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                              locale:
                                                                                  "vi_VI",
                                                                              symbol:
                                                                                  "đ")
                                                                          .format(list[index]
                                                                              [
                                                                              "t_tien"]),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            },
                                          ),
                                        ));
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
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Text(
                                                "Chưa có đơn hàng",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (storageAuth.getItem("phone") != null)
                          FutureBuilder(
                            future: getProfile(storageAuth.getItem("phone")),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List profile = snapshot.data!;
                                return FutureBuilder(
                                  future: callPBLApiStatus(
                                      profile[0]["ma_kh"], "6"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isNotEmpty) {
                                        List list = snapshot.data!;
                                        return Expanded(
                                            child: RefreshIndicator(
                                          onRefresh: refreshData,
                                          child: ListView.builder(
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: index != 0 ? 20 : 30,
                                                      bottom: index ==
                                                              list.length - 1
                                                          ? 20
                                                          : 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 8,
                                                        offset: const Offset(4,
                                                            4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  // height: 135,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ModalChiTietBuy(
                                                                          product:
                                                                              list[index],
                                                                          type:
                                                                              "hoàn thành",
                                                                        )));
                                                      },
                                                      style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all(const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 8)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shape: MaterialStateProperty.all(
                                                            const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)))),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                child: Image
                                                                    .network(
                                                                  "$apiUrl${list[index]["details"][0]!["picture"]}?$token",
                                                                  // width: 110,
                                                                  height: 60,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                        "${list[index]["details"][0]["ten_vt"]}",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${list[index]["details"][0]["sl_xuat"]}",
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          const Text(
                                                                              "x"),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(
                                                                              list[index]["details"][0]["gia_ban_le_goc"],
                                                                            ),
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.primary),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                border: BorderDirectional(
                                                                    top: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors.grey[
                                                                            400]!),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey[400]!))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${list[index]["t_sl_order"]} sản phẩm",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Thành tiền:",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                              locale:
                                                                                  "vi_VI",
                                                                              symbol:
                                                                                  "đ")
                                                                          .format(list[index]
                                                                              [
                                                                              "t_tien"]),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  border: BorderDirectional(
                                                                      bottom: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              Colors.grey[400]!))),
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Đơn hàng đã được giao thành công",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .keyboard_arrow_right,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            },
                                          ),
                                        ));
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
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Text(
                                                "Chưa có đơn hàng",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (storageAuth.getItem("phone") != null)
                          FutureBuilder(
                            future: getProfile(storageAuth.getItem("phone")),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List profile = snapshot.data!;
                                return FutureBuilder(
                                  future: callPBLApiStatus(
                                      profile[0]["ma_kh"], "9"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isNotEmpty) {
                                        List list = snapshot.data!;
                                        return Expanded(
                                            child: RefreshIndicator(
                                          onRefresh: refreshData,
                                          child: ListView.builder(
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: index != 0 ? 20 : 30,
                                                      bottom: index ==
                                                              list.length - 1
                                                          ? 20
                                                          : 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 8,
                                                        offset: const Offset(4,
                                                            4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  // height: 135,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ModalChiTietBuy(
                                                                          product:
                                                                              list[index],
                                                                          type:
                                                                              "hủy đơn",
                                                                        )));
                                                      },
                                                      style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all(const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 8)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        shape: MaterialStateProperty.all(
                                                            const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)))),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                child: Image
                                                                    .network(
                                                                  "$apiUrl${list[index]["details"][0]!["picture"]}?$token",
                                                                  // width: 110,
                                                                  height: 60,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                        "${list[index]["details"][0]["ten_vt"]}",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${list[index]["details"][0]["sl_xuat"]}",
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          const Text(
                                                                              "x"),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(
                                                                              list[index]["details"][0]["gia_ban_le_goc"],
                                                                            ),
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.primary),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                border: BorderDirectional(
                                                                    top: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors.grey[
                                                                            400]!),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey[400]!))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${list[index]["t_sl_order"]} sản phẩm",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Thành tiền:",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                              locale:
                                                                                  "vi_VI",
                                                                              symbol:
                                                                                  "đ")
                                                                          .format(list[index]
                                                                              [
                                                                              "t_tien"]),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            },
                                          ),
                                        ));
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
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Text(
                                                "Chưa có đơn hàng",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
