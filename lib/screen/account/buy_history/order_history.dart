import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/screen/account/buy_history/beauty_profile.dart';
import 'package:ngoc_huong/screen/account/buy_history/modal_chi_tiet_buy.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';

class OrderHistory extends StatefulWidget {
  final List listTab;
  final int? ac;
  const OrderHistory({super.key, required this.listTab, this.ac});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

int? selectedIndex;
int typeOrder = 0;

class _OrderHistoryState extends State<OrderHistory>
    with TickerProviderStateMixin {
  TabController? tabController;
  final OrderModel orderModel = OrderModel();
  void _getActiveTabIndex() {
    setState(() {
      selectedIndex = tabController?.index;
    });
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.listTab.length, vsync: this);
    if (widget.ac != null) {
      tabController?.animateTo(widget.ac!);
    } else {
      tabController?.addListener(_getActiveTabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    typeOrder = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: typeOrder == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    "Mỹ phẩm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: typeOrder == 0 ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                setState(() {
                  typeOrder = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: typeOrder == 1
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  "Dịch vụ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: typeOrder == 1 ? Colors.white : Colors.black),
                ),
              ),
            ))
          ],
        ),
        if (typeOrder == 0)
          widget.listTab.isNotEmpty
              ? Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        controller: tabController,
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
                            selectedIndex = tabIndex;
                          });
                        },
                        tabs: widget.listTab
                            .map((e) => SizedBox(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      10,
                                  child: Tab(
                                    text: "${e["GroupName"]}",
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height - 440,
                        child: TabBarView(
                            controller: tabController,
                            children: widget.listTab
                                .map((e) => FutureBuilder(
                                    future: orderModel
                                        .getOrderListByStatus(e["GroupCode"]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.isNotEmpty &&
                                            snapshot.data![0]["DetailList"]
                                                    .indexWhere((e) =>
                                                        e["ProductCode"]
                                                            .toString()
                                                            .contains("DV")) <
                                                0) {
                                          List list = snapshot.data!;
                                          return RefreshIndicator(
                                            onRefresh: refreshData,
                                            child: ListView.builder(
                                              // controller: scrollController,
                                              itemCount: list.length,
                                              itemBuilder: (context, index) {
                                                return list[index]["DetailList"]
                                                            .isNotEmpty &&
                                                        list[index]["DetailList"]
                                                                .indexWhere((e) => e[
                                                                        "ProductCode"]
                                                                    .toString()
                                                                    .contains(
                                                                        "DV")) <
                                                            0
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: index != 0
                                                                ? 20
                                                                : 30,
                                                            bottom: index ==
                                                                    list.length -
                                                                        1
                                                                ? 20
                                                                : 0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 1,
                                                              blurRadius: 8,
                                                              offset: const Offset(
                                                                  4,
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
                                                                                "",
                                                                            save:
                                                                                () {
                                                                              setState(() {});
                                                                            },
                                                                          )));
                                                            },
                                                            style: ButtonStyle(
                                                              padding: MaterialStateProperty.all(
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          12,
                                                                      horizontal:
                                                                          8)),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                              shape: MaterialStateProperty.all(
                                                                  const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10)))),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              10)),
                                                                      child: Image
                                                                          .network(
                                                                        "${list[index]["DetailList"][0]["Image_Name"]}",
                                                                        // width: 110,
                                                                        height:
                                                                            60,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
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
                                                                              "${list[index]["DetailList"][0]["ProductName"]}",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: const TextStyle(color: Colors.black),
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
                                                                                const Text("x"),
                                                                                const SizedBox(
                                                                                  width: 3,
                                                                                ),
                                                                                Text(
                                                                                  NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(list[index]["DetailList"][0]["Price"]),
                                                                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
                                                                          top:
                                                                              15),
                                                                  padding: const EdgeInsets
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
                                                                              width: 1,
                                                                              color: Colors.grey[400]!))),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "${list[index]["DetailList"].length} sản phẩm",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Text(
                                                                            "Thành tiền:",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w300,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(list[index]["TotalAmount"] == 0
                                                                                ? totalBooking(list[index]["DetailList"])
                                                                                : list[index]["TotalAmount"]),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
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
                                        return const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: LoadingIndicator(
                                                colors: kDefaultRainbowColors,
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
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
                                    }))
                                .toList()))
                  ],
                )
              : const Row(
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
                ),
        if (typeOrder == 1) BeautyProfile()
      ],
    );
  }
}
