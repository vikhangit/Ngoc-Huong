import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/screen/gift_shop/chi_tiet_uu_dai.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

String showIndex = "";

class _AllProductScreenState extends State<AllProductScreen> {
  final ProductModel productModel = ProductModel();
  final CustomModal customModal = CustomModal();
  final CartModel cartModel = CartModel();
  final ScrollController scrollController = ScrollController();

  final LocalStorage storageToken = LocalStorage("customer_token");

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    setState(() {
      showIndex = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    showIndex = "";
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: Platform.isAndroid ? 75 : 100,
                child: const MyBottomMenu(
                  active: 0,
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
              title: const Text("Sản phẩm",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: FutureBuilder(
                  future: productModel.getHotProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.toList();
                      return ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          children: [
                            Wrap(
                                runSpacing: 15,
                                alignment: WrapAlignment.spaceBetween,
                                children: list.map((item) {
                                  return GestureDetector(
                                      onTap: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GiftShopDetail(
                                                          details: item,
                                                          type: "product",
                                                        )))
                                          },
                                      child: Stack(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  22.5,
                                              height: 285,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15)),
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 140,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.3),
                                                                spreadRadius: 2,
                                                                blurRadius: 2,
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
                                                            child:
                                                                Image.network(
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: mainColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "${item["CategoryCode"]}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            height: 1.2,
                                                            color: mainColor,
                                                            fontStyle: FontStyle
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
                                                    padding: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8)),
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
                                                    child: GestureDetector(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          8)),
                                                              color: mainColor,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/images/icon/Xu1.png",
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  "10.000",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ))),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ));
                                }).toList())
                          ]);
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
                ))));
  }
}
