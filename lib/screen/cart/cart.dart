import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/checkout/checkout.dart';
import 'package:ngoc_huong/screen/services/my_pham.dart';
import 'package:ngoc_huong/screen/services/phu_xam.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

int? _selectedIndex;
int quantity = 1;
int clickIndex = -1;

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  Color checkColor(int index) {
    Color color = Colors.black;
    switch (index) {
      case 0:
        {
          return Colors.pink[50]!;
        }
      case 1:
        {
          return Colors.greenAccent[100]!;
        }
      case 2:
        {
          return Colors.lightBlue[100]!;
        }
      case 3:
        {
          return Colors.grey[300]!;
        }
      case 4:
        {
          return Colors.orangeAccent[100]!;
        }
      case 5:
        {
          return Colors.black12;
        }
      default:
        {}
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: const MyBottomMenu(
            active: 1,
          ),
          appBar: AppBar(
            // bottomOpacity: 0.0,
            primary: false,
            elevation: 0.0,
            leadingWidth: 40,
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.west,
                size: 24,
                color: Colors.black,
              ),
            ),
            title: const Text("Giỏi hàng",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            bottom: TabBar(
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
                    text: "Dịch vụ",
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 45,
                  child: const Tab(
                    text: "Sản phẩm",
                  ),
                )
              ],
            ),
          ),
          drawer: const MyLeftMenu(),
          body: SizedBox(
            child: Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: loaidichvu.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: index != 0 ? 20 : 30,
                                  bottom:
                                      index == loaidichvu.length - 1 ? 20 : 0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 145,
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 8)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.asset(
                                        "assets/images/Services/PhunXamMay/img1.jpg",
                                        width: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          children: [
                                            const Text(
                                              "Phun xăm môi-Cấy son tươi Hàn Quốc",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: const Text(
                                                  "Cấy son tươi Hàn Quốc là phương pháp độc quyền tại Hệ thống TMV Ngọc Hường",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )),
                                            Text(
                                              "899.000đ",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(
                                4, 4), // changes position of shadow
                          ),
                        ]),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tổng hóa đơn:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  "899.000đ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              ],
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(bottom: 30, top: 20),
                                child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20)),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40)))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.4))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CheckOutScreen()));
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(flex: 1, child: Container()),
                                        const Expanded(
                                          flex: 8,
                                          child: Center(
                                            child: Text(
                                              "Thanh toán",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Image.asset(
                                            "assets/images/calendar-black.png",
                                            width: 40,
                                            height: 30,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      ],
                                    )))
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: listDeXuat.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: index != 0 ? 20 : 30,
                                  bottom:
                                      index == listDeXuat.length - 1 ? 20 : 0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 145,
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 8)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Container(
                                          color: checkColor(index),
                                          child: Image.asset(
                                            listDeXuat[index]["img"],
                                            width: 90,
                                            fit: BoxFit.contain,
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          children: [
                                            Text(
                                              listDeXuat[index]["title"],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8, bottom: 12),
                                                child: const Text(
                                                  "Cấy son tươi Hàn Quốc là phương pháp độc quyền tại Hệ thống TMV Ngọc Hường",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "899.000đ",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          clickIndex = index;
                                                        });
                                                        if (clickIndex ==
                                                            index) {
                                                          setState(() {
                                                            quantity--;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 25,
                                                        height: 25,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .orange),
                                                            shape: BoxShape
                                                                .circle),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Text(
                                                        "$quantity",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          clickIndex = index;
                                                        });
                                                        if (clickIndex ==
                                                            index) {
                                                          setState(() {
                                                            quantity++;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 25,
                                                        height: 25,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .orange),
                                                            shape: BoxShape
                                                                .circle),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(
                                4, 4), // changes position of shadow
                          ),
                        ]),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tổng hóa đơn:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  "899.000đ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              ],
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(bottom: 30, top: 20),
                                child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20)),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40)))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.4))),
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Expanded(flex: 1, child: Container()),
                                        const Expanded(
                                          flex: 8,
                                          child: Center(
                                            child: Text(
                                              "Thanh toán",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Image.asset(
                                            "assets/images/cart-black.png",
                                            width: 40,
                                            height: 30,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      ],
                                    )))
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
