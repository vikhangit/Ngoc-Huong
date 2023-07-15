import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/checkout/products/checkout_cart.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

int? _selectedIndex;
int quantity = 1;
int clickIndex = -1;
bool checkBoxValue = false;
List listCheckout = [];

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  LocalStorage storageAuth = LocalStorage("auth");
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    setState(() {
      listCheckout = [];
    });
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void updateCart(String id, int qty) async {
    if (quantity <= 0) {
      // showAlertDialog(context, "Số lượng phải lớn hơn 0");
    } else {
      Map data = {"sl_xuat": qty};
      await putCart(id, data).then((value) {
        if (listCheckout.isNotEmpty) {
          int idx = listCheckout
              .indexWhere((item) => item["ma_vt"] == value["ma_vt"]);
          if (idx < 0) {
            setState(() {});
          } else {
            setState(() {
              listCheckout[idx] = value;
            });
          }
        } else {
          setState(() {});
        }
        // } else {
        //   color = Colors.white;
        // }
        print(value);
      });
    }
  }

  void deleteProductInCart(String id) async {
    await deleteCart(id);
    setState(() {});
  }

  void showAlertDialog(BuildContext context, String err) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            // height: 30,
            width: MediaQuery.of(context).size.width,
            child: Text(
              style: const TextStyle(height: 1.6),
              err,
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void onLoading(String id, int qty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 1), () {
        updateCart(id, qty);
        Navigator.pop(context);
      });
    }

    void onLoadingDelete(String id) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        deleteProductInCart(id);
        Navigator.pop(context);
      });
    }

    void showInfoDialog(BuildContext context, String id) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                return SizedBox(
                    // height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info,
                          size: 70,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Xóa sản phẩm",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Bạn có muốn xóa sản phẩm ra khỏi giỏ hàng?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        )
                      ],
                    ));
              },
            ),
            actionsPadding:
                const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onLoadingDelete(id);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15)),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary)),
                  child: const Text(
                    "Đồng ý",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 15)),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            side: BorderSide(color: Colors.grey, width: 1))),
                  ),
                  child: const Text("Hủy bỏ"),
                ),
              )
            ],
          );
        },
      );
    }

    num totalCat() {
      num total = 0;
      if (listCheckout.isNotEmpty) {
        for (var i = 0; i < listCheckout.length; i++) {
          total += listCheckout[i]["tien"];
        }
      } else {
        total = 0;
      }
      return total;
    }

    Color checkColor(Map it) {
      Color color = Colors.white;
      if (listCheckout.isNotEmpty) {
        int idx =
            listCheckout.indexWhere((item) => item["ma_vt"] == it["ma_vt"]);
        if (idx < 0) {
          color = Colors.white;
        } else {
          color = Colors.green;
        }
      } else {
        color = Colors.white;
      }
      return color;
    }

    Color checkColorBorder(Map it) {
      Color color = Colors.grey;
      if (listCheckout.isNotEmpty) {
        int idx =
            listCheckout.indexWhere((item) => item["ma_vt"] == it["ma_vt"]);
        if (idx < 0) {
          color = Colors.grey;
        } else {
          color = Colors.green;
        }
      } else {
        color = Colors.grey;
      }
      return color;
    }

    checkIcon(Map it) {
      if (listCheckout.isNotEmpty) {
        int idx =
            listCheckout.indexWhere((item) => item["ma_vt"] == it["ma_vt"]);
        if (idx < 0) {
          return null;
        } else {
          return const Icon(
            Icons.check,
            color: Colors.white,
            size: 18,
          );
        }
      } else {
        return null;
      }
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: const MyBottomMenu(
            active: 1,
          ),
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: InkWell(
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
            title: const Text("Giỏ hàng",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          drawer: const MyLeftMenu(),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                  future: callCartApi(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.toList();
                      if (list.isNotEmpty) {
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
                                      bottom:
                                          index == list.length - 1 ? 20 : 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                  height: 156,
                                  child: FutureBuilder(
                                    future: callProductApiByName(
                                        list[index]["ten_vt"]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                  color:
                                                      checkColor(list[index]),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: checkColorBorder(
                                                          list[index])),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (listCheckout
                                                          .isNotEmpty) {
                                                        int idx = listCheckout
                                                            .indexWhere((item) =>
                                                                item["ma_vt"] ==
                                                                list[index]
                                                                    ["ma_vt"]);
                                                        if (idx < 0) {
                                                          listCheckout
                                                              .add(list[index]);
                                                        } else {
                                                          listCheckout
                                                              .removeAt(idx);
                                                        }
                                                      } else {
                                                        listCheckout
                                                            .add(list[index]);
                                                      }
                                                    });
                                                  },
                                                  child:
                                                      checkIcon(list[index])),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70,
                                              child: TextButton(
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
                                                              bottom: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets
                                                                  .bottom),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.95,
                                                          child: ProductDetail(
                                                            details: snapshot
                                                                .data![0],
                                                          ),
                                                        );
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
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        child: Image.network(
                                                          "$apiUrl${list[index]["picture"]}?$token",
                                                          width: 90,
                                                          height: 140,
                                                          fit: BoxFit.cover,
                                                        )),
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
                                                              snapshot.data![
                                                                  0]!["ten_vt"],
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
                                                                        top: 8,
                                                                        bottom:
                                                                            12),
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
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  NumberFormat.currency(
                                                                          locale:
                                                                              "vi_VI",
                                                                          symbol:
                                                                              "đ")
                                                                      .format(snapshot
                                                                              .data![0]![
                                                                          "gia_ban_le"]),
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        onLoading(
                                                                            list[index][
                                                                                "_id"],
                                                                            list[index]["sl_xuat"] -
                                                                                1);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1, color: Colors.orange),
                                                                            shape: BoxShape.circle),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .remove,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              Colors.orange,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        "${list[index]["sl_xuat"]}",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w300),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        onLoading(
                                                                            list[index][
                                                                                "_id"],
                                                                            list[index]["sl_xuat"] +
                                                                                1);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1, color: Colors.orange),
                                                                            shape: BoxShape.circle),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              Colors.orange,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6),
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    showInfoDialog(
                                                                        context,
                                                                        list[index]
                                                                            [
                                                                            "_id"]);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/delete-red.png",
                                                                        width:
                                                                            16,
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "Xóa",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color: Theme.of(context).colorScheme.primary),
                                                                      )
                                                                    ],
                                                                  )),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ));
                            },
                          ),
                        ));
                      } else {
                        return Container(
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
                            ));
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: callCartApi(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!;
                      if (list.isNotEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 2, color: Colors.grey[200]!))),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tổng thanh toán",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        NumberFormat.currency(
                                                locale: "vi_VI", symbol: "")
                                            .format(totalCat()),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      Text(
                                        "đ",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 30, top: 20),
                                  child: TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 20)),
                                          shape: MaterialStateProperty.all(
                                              const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15)))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.4))),
                                      onPressed: () {
                                        if (listCheckout.isNotEmpty) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckOutCart(
                                                        listCart: listCheckout,
                                                        total: totalCat(),
                                                      )));
                                        } else {
                                          showAlertDialog(context,
                                              "Bạn vẫn chưa chọn sản phẩm để mua");
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(flex: 1, child: Container()),
                                          const Expanded(
                                            flex: 8,
                                            child: Center(
                                              child: Text(
                                                "Đặt hàng",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}
