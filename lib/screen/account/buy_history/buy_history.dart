import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/account/buy_history/modal_chi_tiet_buy.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';

class BuyHistory extends StatefulWidget {
  final int? ac;
  const BuyHistory({super.key, this.ac});

  @override
  State<BuyHistory> createState() => _BuyHistoryState();
}

int? _selectedIndex;

class _BuyHistoryState extends State<BuyHistory> with TickerProviderStateMixin {
  TabController? tabController;
  final OrderModel orderModel = OrderModel();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

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

  num totalBooking(List list) {
    num total = 0;
    for (var i = 0; i < list.length; i++) {
      num total = 0;
      for (var i = 0; i < list.length; i++) {
        total += list[i]["Amount"];
      }
      return total;
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const AccountScreen())));
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
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 3 - 15,
                    //   child: const Tab(
                    //     text: "Đã xác nhận",
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 3 - 15,
                    //   child: const Tab(
                    //     text: "Đang giao",
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 3 - 15,
                    //   child: const Tab(
                    //     text: "Đã giao",
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 15,
                      child: const Tab(
                        text: "Đã thanh toán",
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
                    FutureBuilder(
                      future: orderModel.getOrderListByStatus("pending"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            List list = snapshot.data!;
                            return RefreshIndicator(
                              onRefresh: refreshData,
                              child: ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return list[index]["DetailList"].isNotEmpty
                                      ? Container(
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
                                                        builder: (context) =>
                                                            ModalChiTietBuy(
                                                              product:
                                                                  list[index],
                                                              type: "",
                                                              save: save,
                                                            )));
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
                                                                Radius.circular(
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
                                                        child: Image.network(
                                                          "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                                          // width: 110,
                                                          height: 60,
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
                                                                "${list[index]["DetailList"][0]["Product"]["Name"]}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${list[index]["DetailList"][0]["Quantity"] ?? 1}",
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  const Text(
                                                                      "x"),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                "vi_VI",
                                                                            symbol:
                                                                                "đ")
                                                                        .format(list[index]["DetailList"][0]["Product"]
                                                                            [
                                                                            "PriceOutbound"]),
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary),
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
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        border: BorderDirectional(
                                                            top: BorderSide(
                                                                width: 1,
                                                                color:
                                                                    Colors.grey[
                                                                        400]!),
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                        .grey[
                                                                    400]!))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${list[index]["DetailList"].length} sản phẩm",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
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
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                              "${list[index]["TotalAmount"] == 0 ? NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(totalBooking(list[index]["DetailList"])) : list[index]["TotalAmount"]}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )))
                                      : Container();
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
                                    "Chưa có đơn hàng",
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
                              child: Row(
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
                          ));
                        }
                      },
                    ),
                    FutureBuilder(
                      future: orderModel.getOrderListByStatus("complete"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            List list = snapshot.data!.toList();
                            return RefreshIndicator(
                              onRefresh: refreshData,
                              child: ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return list[index]["DetailList"].isNotEmpty
                                      ? Container(
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
                                                        builder: (context) =>
                                                            ModalChiTietBuy(
                                                              product:
                                                                  list[index],
                                                              type:
                                                                  "thanh toán",
                                                              save: save,
                                                            )));
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
                                                                Radius.circular(
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
                                                        child: Image.network(
                                                          "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                                          // width: 110,
                                                          height: 60,
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
                                                                "${list[index]["DetailList"][0]["Product"]["Name"]}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${list[index]["DetailList"][0]["Quantity"] ?? 1}",
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  const Text(
                                                                      "x"),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                "vi_VI",
                                                                            symbol:
                                                                                "đ")
                                                                        .format(list[index]["DetailList"][0]["Product"]
                                                                            [
                                                                            "PriceOutbound"]),
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary),
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
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        border: BorderDirectional(
                                                            top: BorderSide(
                                                                width: 1,
                                                                color:
                                                                    Colors.grey[
                                                                        400]!),
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                        .grey[
                                                                    400]!))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${list[index]["DetailList"].length} sản phẩm",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
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
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                              "${list[index]["TotalAmount"] == 0 ? NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(totalBooking(list[index]["DetailList"])) : list[index]["TotalAmount"]}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )))
                                      : Container();
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
                                    "Chưa có đơn hàng",
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
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                            ],
                          ));
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
