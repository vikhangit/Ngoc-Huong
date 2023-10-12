import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/checkout/products/checkout_cart.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
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
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  final CustomModal customModal = CustomModal();
  final CartModel cartModel = CartModel();
  final ProductModel productModel = ProductModel();
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

  void updateCart(Map item, int qty) async {
    if (quantity <= 0) {
      // showAlertDialog(context, "Số lượng phải lớn hơn 0");
    } else {
      Map data = {
        "Id": 1,
        "DetailList": [
          {
            "Id": item["Id"],
            "Quantity": quantity
          }
        ]
      };
      cartModel.updateProductInCart(data).then((value) {
        // if (listCheckout.isNotEmpty) {
        //   int idx = listCheckout
        //       .indexWhere((item) => item["Id"] == value["Id"]);
        //   if (idx < 0) {
        //     setState(() {});
        //   } else {
        //     setState(() {
        //       listCheckout[idx] = value;
        //     });
        //   }
        // } else {
        //   setState(() {});
        // }
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

  @override
  Widget build(BuildContext context) {
    num totalCat() {
      num total = 0;
      if (listCheckout.isNotEmpty) {
        for (var i = 0; i < listCheckout.length; i++) {
          total += listCheckout[i]["Price"] * listCheckout[i]["Quantity"] ;
        }
      } else {
        total = 0;
      }
      return total;
    }

    Color checkColor(Map it) {
      Color color = Colors.white;
      if (listCheckout.isNotEmpty) {
        int idx = listCheckout.indexWhere(
            (item) => item["Id"] == it["Id"]);
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
        int idx = listCheckout.indexWhere(
            (item) => item["Id"] == it["Id"]);
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
        int idx = listCheckout.indexWhere(
            (item) => item["Id"] == it["Id"]);
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

    // void updateQuantity(Map item){
    //   const
    // }
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: const MyBottomMenu(active: 1),
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
            title: const Text("Giỏ hàng",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          body: SizedBox(
              child: FutureBuilder(
            future: cartModel.getProductCartList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
               List allCart =  snapshot.data!.toList();
                if (allCart.isNotEmpty) {
                  print(allCart);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height - 355,
                          child: ListView(
                            children: allCart.map((ele) {
                              int index = allCart.toList().indexOf(ele);
                              return Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 20 : 30,
                                      bottom:
                                          index == allCart.length - 1 ? 20 : 0),
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
                                  height: 115,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            color: checkColor(
                                                allCart[index]),
                                            border: Border.all(
                                                width: 1,
                                                color: checkColorBorder(
                                                    allCart[index])),
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(8))),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (listCheckout
                                                    .isNotEmpty) {
                                                  int idx = listCheckout
                                                      .indexWhere((item) =>
                                                  item[
                                                  "Id"] ==
                                                      ele["Id"]);
                                                  if (idx < 0) {
                                                    listCheckout
                                                        .add(ele);
                                                  } else {
                                                    listCheckout
                                                        .removeAt(idx);
                                                  }
                                                } else {
                                                  listCheckout
                                                      .add(ele);
                                                }
                                              });
                                            },
                                            child: checkIcon(
                                                allCart[index])),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            left: 5),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width -
                                            70,
                                        child: FutureBuilder(
                                          future: productModel.getProductCode(ele["ProductCode"]),
                                          builder: (context, snapshot) {
                                            if(snapshot.hasData){
                                              Map detail = snapshot.data!;
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
                                                            details: detail,
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
                                                         "${detail["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                                          width: 90,
                                                          height: 110,
                                                          fit: BoxFit.cover,
                                                        )),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "${ele["ProductName"]}",
                                                              style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Container(
                                                              margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(ele["Price"]),
                                                                    style: TextStyle(
                                                                        color: Theme.of(
                                                                            context)
                                                                            .colorScheme
                                                                            .primary),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          EasyLoading.show(
                                                                              status:
                                                                              "Đang xử lý...");
                                                                          Future.delayed(
                                                                              const Duration(
                                                                                  seconds:
                                                                                  1),
                                                                                  () {
                                                                                Map data = {
                                                                                  "Id": 1,
                                                                                  "DetailList": [
                                                                                    {
                                                                                      ...ele,
                                                                                      "Quantity": ele["Quantity"] - 1
                                                                                    }
                                                                                  ]
                                                                                };
                                                                                cartModel
                                                                                    .updateProductInCart(data)
                                                                                    .then(
                                                                                        (value) {
                                                                                      if (listCheckout
                                                                                          .isNotEmpty) {
                                                                                        int idx = listCheckout.indexWhere((item) =>
                                                                                        item["Id"] ==
                                                                                            allCart[index]["Id"]);
                                                                                        if (idx <
                                                                                            0) {
                                                                                          setState(
                                                                                                  () {});
                                                                                        } else {
                                                                                          setState(
                                                                                                  () {
                                                                                                listCheckout[idx]["quantity"]--;
                                                                                              });
                                                                                        }
                                                                                      } else {
                                                                                        setState(
                                                                                                () {});
                                                                                      }
                                                                                      EasyLoading
                                                                                          .dismiss();
                                                                                    });
                                                                              });

                                                                        },
                                                                        child:
                                                                        Container(
                                                                          width: 25,
                                                                          height:
                                                                          25,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 1,
                                                                                  color: Colors.orange),
                                                                              shape: BoxShape.circle),
                                                                          alignment:
                                                                          Alignment
                                                                              .center,
                                                                          child:
                                                                          const Icon(
                                                                            Icons
                                                                                .remove,
                                                                            size:
                                                                            16,
                                                                            color: Colors
                                                                                .orange,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                            10),
                                                                        child: Text(
                                                                          "${ele["Quantity"]}",
                                                                          style: const TextStyle(
                                                                              fontWeight:
                                                                              FontWeight.w300),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          EasyLoading.show(
                                                                              status:
                                                                              "Đang xử lý...");
                                                                          Future.delayed(
                                                                              const Duration(
                                                                                  seconds:
                                                                                  1),
                                                                                  () {
                                                                                cartModel
                                                                                    .updateProductInCart({
                                                                                  "Id": 1,
                                                                                  "DetailList": [
                                                                                    {
                                                                                      ...ele,
                                                                                      "Quantity": ele["Quantity"] + 1
                                                                                    }
                                                                                  ]
                                                                                })
                                                                                    .then(
                                                                                        (value) {
                                                                                      if (listCheckout
                                                                                          .isNotEmpty) {
                                                                                        int idx = listCheckout.indexWhere((item) =>
                                                                                        item["Id"] ==
                                                                                            allCart[index]["Id"]);
                                                                                        if (idx <
                                                                                            0) {
                                                                                          setState(
                                                                                                  () {});
                                                                                        } else {
                                                                                          setState(
                                                                                                  () {
                                                                                                listCheckout[idx]["quantity"]++;
                                                                                              });
                                                                                        }
                                                                                      } else {
                                                                                        setState(
                                                                                                () {});
                                                                                      }
                                                                                      EasyLoading
                                                                                          .dismiss();
                                                                                    });
                                                                              });

                                                                        },
                                                                        child:
                                                                        Container(
                                                                          width: 25,
                                                                          height:
                                                                          25,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 1,
                                                                                  color: Colors.orange),
                                                                              shape: BoxShape.circle),
                                                                          alignment:
                                                                          Alignment
                                                                              .center,
                                                                          child:
                                                                          const Icon(
                                                                            Icons
                                                                                .add,
                                                                            size:
                                                                            16,
                                                                            color: Colors
                                                                                .orange,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    customModal.showAlertDialog(
                                                                        context,
                                                                        "error",
                                                                        "Xóa sản phẩm",
                                                                        "Bạn có chắc chắn xóa sản phẩm này?",
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          EasyLoading.show(
                                                                              status:
                                                                              "Đang xử lý...");
                                                                          Future.delayed(
                                                                              const Duration(
                                                                                  seconds:
                                                                                  1),
                                                                                  () {
                                                                                cartModel.updateProductInCart({
                                                                                  "Id": 1,
                                                                                  "DetailList": [
                                                                                    {
                                                                                      ...ele,
                                                                                      "IsDeleted": true
                                                                                    }
                                                                                  ]
                                                                                })
                                                                                    .then(
                                                                                        (value) {
                                                                                      setState(() {
                                                                                        EasyLoading
                                                                                            .dismiss();
                                                                                      });
                                                                                    });
                                                                              });
                                                                        },
                                                                            () => Navigator
                                                                            .pop(
                                                                            context));

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
                                                        ))
                                                  ],
                                                ),
                                              );
                                            }else{
                                              return Container();
                                            }
                                          },
                                        )
                                      ),
                                    ],
                                  ));
                            }).toList(),
                          )),
                      Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                margin:
                                    const EdgeInsets.only(bottom: 30, top: 20),
                                child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 20)),
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
                                        customModal.showAlertDialog(
                                            context,
                                            "error",
                                            "Đặt Hàng",
                                            "Bạn chưa chọn sản phẩm đặt hàng",
                                            () => Navigator.pop(context),
                                            () => Navigator.pop(context));
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
                  );
                } else {
                  return Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 40, bottom: 15),
                            child:
                                Image.asset("assets/images/account/img.webp"),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Text(
                              "Chưa có sản phẩm trong giỏ hàng",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ));
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
                  ),
                );
              }
            },
          ))),
    );
  }
}
