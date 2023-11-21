import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class Cosmetic extends StatefulWidget {
  final List listTab;
  const Cosmetic({super.key, required this.listTab});

  @override
  State<Cosmetic> createState() => _CosmeticState();
}

List listAction = [];

String showIndex = "";
String activeCode = listAction[0]["code"];

class _CosmeticState extends State<Cosmetic> {
  final ProductModel productModel = ProductModel();
  final CustomModal customModal = CustomModal();
  final CartModel cartModel = CartModel();

  final LocalStorage storageToken = LocalStorage("customer_token");

  @override
  void initState() {
    super.initState();
    setState(() {
      showIndex = "";
      listAction.clear();
    });
    setState(() {
      widget.listTab.map((e) {
        if (e["GroupCode"] != "GDC") {
          if (e["GroupCode"].toString().contains("làm trắng")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/lam-trang.png",
              "title": "Làm trắng",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"].toString().contains("dinh dưỡng cho da")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/dinh-duong-da.png",
              "title": "Dinh dưỡng cho da",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"].toString().contains("nâng cơ")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/nang-co.png",
              "title": "Nâng cơ - Giảm nhăn",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"].toString().contains("dành cho mắt")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/danh-cho-mat.png",
              "title": "Dành cho mắt",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"]
              .toString()
              .contains("nuôi dưỡng và phục hồi da")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/nuoi-duong.png",
              "title": "Nuôi dưỡng và phục hồi",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"].toString().contains("dành cho da mụn")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/nuoi-duong.png",
              "title": "Nuôi dưỡng và phục hồi",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"].toString().contains("dành cho da mụn")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/da-mun.png",
              "title": "Dành cho da mụn",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"].toString().contains("dành cho dưỡng môi")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/duong-moi.png",
              "title": "Dưỡng môi",
              "code": e["GroupCode"]
            });
          } else if (e["GroupCode"].toString().contains("dành cho dưỡng môi")) {
            listAction.add({
              "img": "assets/images/Services/MyPham/Icon/lam-sach.png",
              "title": "Làm sạch",
              "code": e["GroupCode"]
            });
          }
        }
      }).toList();
      activeCode = listAction[0]["code"];
    });
  }

  @override
  void dispose() {
    super.dispose();
    showIndex = "";
  }

  void addToCart(Map item) async {
    // customModal.showAlertDialog(context, "error", "Giỏ hàng",
    //     "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
    //   Navigator.pop(context);
    //   EasyLoading.show(status: "Vui lòng chờ...");
    //   Future.delayed(const Duration(seconds: 2), () {
    //     cartModel.addProductToCart({"quantity": 1, ...item}).then((value) {
    //       EasyLoading.dismiss();
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => const AddCartSuccess()));
    //     });
    //   });
    // }, () => Navigator.pop(context));

    Map data = {
      "DetailList": [
        {
          "Amount": item["PriceOutbound"] * 1,
          "Price": item["PriceOutbound"],
          "ProductCode": item["Code"],
          "ProductId": item["Id"],
          "Quantity": 1,
        }
      ]
    };
    customModal.showAlertDialog(context, "error", "Giỏ hàng",
        "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
      Navigator.pop(context);
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        cartModel.addToCart(data).then((value) {
          print(value);
          EasyLoading.dismiss();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCartSuccess()));
        });
      });
    }, () => Navigator.pop(context));
  }

  void goToAction(String code) {
    setState(() {
      activeCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(listAction);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(active: 3),
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
              title: const Text("Mỹ phẩm",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 5,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width * .25,
                      child: ListView(
                        children: listAction.map((item) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    left: activeCode == item["code"]
                                        ? const BorderSide(
                                            width: 3, color: Colors.red)
                                        : BorderSide.none)),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 18, horizontal: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      activeCode == item["code"]
                                          ? Colors.red[100]
                                          : Colors.blue[100]),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))))),
                              onPressed: () {
                                goToAction(item["code"]);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    item["img"],
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                      child: Text(
                                    item["title"],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ))
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75 - 10,
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: productModel.getProductByGroup(activeCode),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List list = snapshot.data!.toList();
                                return Wrap(
                                    // runSpacing: 8,
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
                                                              .width *
                                                          .7 /
                                                          2 -
                                                      5,
                                                  height: 260,
                                                  margin: EdgeInsets.only(
                                                      left: 2,
                                                      right: 2,
                                                      top: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        offset: Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 6),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 120,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            15)),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        2,
                                                                    offset: Offset(
                                                                        0,
                                                                        1), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                child: Image
                                                                    .network(
                                                                  "${item["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              )),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "${item["Name"]}",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    mainColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${item["CategoryCode"]}",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                height: 1.2,
                                                                color:
                                                                    mainColor,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8)),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              spreadRadius: 2,
                                                              blurRadius: 2,
                                                              offset: Offset(0,
                                                                  1), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: GestureDetector(
                                                            child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            color: mainColor,
                                                          ),
                                                          child: Text(
                                                              "${NumberFormat.currency(locale: "vi_VI", symbol: "").format(item["PriceInbound"])} Đ",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .amber)),
                                                        )),
                                                      )
                                                    ],
                                                  )),
                                              if (showIndex.isNotEmpty &&
                                                  showIndex == item["Code"])
                                                Positioned.fill(
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        margin: EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            top: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showIndex =
                                                                        "";
                                                                  });
                                                                  showModalBottomSheet<
                                                                          void>(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      clipBehavior:
                                                                          Clip
                                                                              .antiAliasWithSaveLayer,
                                                                      context:
                                                                          context,
                                                                      isScrollControlled:
                                                                          true,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            height: MediaQuery.of(context).size.height * 0.85,
                                                                            child: ProductDetail(
                                                                              details: item,
                                                                            ));
                                                                      });
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                6,
                                                                            horizontal:
                                                                                10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.blue[500],
                                                                          borderRadius: const BorderRadius
                                                                              .all(
                                                                              Radius.circular(4)),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset("assets/images/eye-white.png",
                                                                                width: 18,
                                                                                height: 18),
                                                                            const SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            const Text(
                                                                              "Xem chi tiết",
                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400),
                                                                            )
                                                                          ],
                                                                        ))),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showIndex =
                                                                        "";
                                                                  });
                                                                  if (storageToken
                                                                          .getItem(
                                                                              "customer_token") ==
                                                                      null) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const LoginScreen()));
                                                                  } else {
                                                                    addToCart(
                                                                        item);
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                10),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                6,
                                                                            horizontal:
                                                                                10),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: const BorderRadius.all(Radius.circular(
                                                                                4)),
                                                                            color: Colors.blue[
                                                                                900]),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset("assets/images/cart-solid-white.png",
                                                                                width: 18,
                                                                                height: 18),
                                                                            const SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            const Text(
                                                                              "Mua hàng",
                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400),
                                                                            )
                                                                          ],
                                                                        )))
                                                          ],
                                                        )))
                                            ],
                                          ));
                                    }).toList());
                              } else {
                                return Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height -
                                        250,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: LoadingIndicator(
                                            colors: kDefaultRainbowColors,
                                            indicatorType:
                                                Indicator.lineSpinFadeLoader,
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
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
