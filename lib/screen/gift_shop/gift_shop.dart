import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/memberModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/check_in/CheckIn.dart';
import 'package:ngoc_huong/screen/cosmetic/cosmetic.dart';
import 'package:ngoc_huong/screen/gift_shop/product.dart';
import 'package:ngoc_huong/screen/gift_shop/service.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/mission/mission.dart';
import 'package:ngoc_huong/screen/services/all_service.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class GiftShop extends StatefulWidget {
  const GiftShop({super.key});

  @override
  State<GiftShop> createState() => _GiftShopState();
}

Map profile = {};
List rank = [];

class _GiftShopState extends State<GiftShop> {
  final ProfileModel profileModel = ProfileModel();
  final ScrollController scrollController = ScrollController();
  final ServicesModel servicesModel = ServicesModel();
  final ProductModel productModel = ProductModel();
  final MemberModel memberModel = MemberModel();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    profileModel.getProfile().then((value) => setState(() {
          profile = value;
        }));
    memberModel.getAllRank().then((value) => setState(() {
          rank = value.toList();
        }));
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  String checkRank(int ponit) {
    if (ponit < rank[1]["PointUpLevel"]) {
      return rank[0]["CardName"];
    } else if (ponit >= rank[1]["PointUpLevel"] &&
        ponit < rank[2]["PointUpLevel"]) {
      return rank[1]["CardName"];
    } else if (ponit >= rank[2]["PointUpLevel"] &&
        ponit < rank[3]["PointUpLevel"]) {
      return rank[2]["CardName"];
    } else if (ponit >= rank[3]["PointUpLevel"]) {
      return rank[3]["CardName"];
    }
    return rank[0]["CardName"];
  }

  String checkRankWithName(String rank) {
    rank = rank.toUpperCase();
    if (rank == "SILVER") {
      return "Bạc";
    } else if (rank == "GOLD") {
      return "Vàng";
    } else if (rank == "PLATINUM") {
      return "Bạc kim";
    } else if (rank == "DIAMOND") {
      return "Kim cương";
    }
    return "Bạc";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                callBack: () {
                                  setState(() {});
                                },
                              )));
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
            title: const Text("Shop quà tặng",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: Platform.isAndroid ? 75 : 100,
              child: const MyBottomMenu(
                active: 0,
              )),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: RefreshIndicator(
                  onRefresh: () => refreshData(),
                  child: ListView(
                    controller: scrollController,
                    // padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountScreen()));
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          profile.isNotEmpty
                                              ? Text(profile["CustomerName"]
                                                  .toString()
                                                  .toUpperCase())
                                              : const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: LoadingIndicator(
                                                    colors:
                                                        kDefaultRainbowColors,
                                                    indicatorType: Indicator
                                                        .lineSpinFadeLoader,
                                                    strokeWidth: 1,
                                                  ),
                                                ),
                                          profile.isNotEmpty
                                              ? profile["CardRank"] != null
                                                  ? Text(
                                                      "Hạng ${checkRankWithName(profile["CardRank"])}")
                                                  : Text(
                                                      "Hạng ${checkRank(profile["Point"])}")
                                              : const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: LoadingIndicator(
                                                    colors:
                                                        kDefaultRainbowColors,
                                                    indicatorType: Indicator
                                                        .lineSpinFadeLoader,
                                                    strokeWidth: 1,
                                                  ),
                                                ),
                                          profile.isNotEmpty
                                              ? Row(
                                                  children: [
                                                    const Text("Xu đang có: "),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${profile["CustomerCoin"] ?? 0}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      width: 1,
                                                    ),
                                                    Image.asset(
                                                      "assets/images/icon/Xu1.png",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: LoadingIndicator(
                                                    colors:
                                                        kDefaultRainbowColors,
                                                    indicatorType: Indicator
                                                        .lineSpinFadeLoader,
                                                    strokeWidth: 1,
                                                  ),
                                                ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 20,
                                        weight: 300,
                                      )
                                    ],
                                  )),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => {
                                productModel
                                    .getGroupProduct()
                                    .then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Cosmetic(
                                                  listTab: value,
                                                  isShop: true,
                                                ))))
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Image.asset(
                                      "assets/images/icon/my-pham.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Sảm phẩm",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            GestureDetector(
                              onTap: () => servicesModel
                                  .getGroupServiceByBranch()
                                  .then((value) => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AllServiceScreen(
                                                      listTab: value,
                                                      isShop: true,
                                                    )))
                                      }),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Image.asset(
                                      "assets/images/dieu-tri.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Dịch vụ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            // GestureDetector(
                            //   onTap: () => Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               const AllVoucherScreen())),
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 10, vertical: 10),
                            //         decoration: BoxDecoration(
                            //             color: Theme.of(context)
                            //                 .colorScheme
                            //                 .primary
                            //                 .withOpacity(0.2),
                            //             borderRadius: const BorderRadius.all(
                            //                 Radius.circular(15))),
                            //         child: Image.asset(
                            //           "assets/images/Home/Services/thanh-vien.png",
                            //           width: 40,
                            //           height: 40,
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         height: 8,
                            //       ),
                            //       const Text(
                            //         "Quà đối tác",
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: 14),
                            //       )
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CheckIn(save: () {
                        setState(() {
                          profileModel
                              .getProfile()
                              .then((value) => setState(() {
                                    profile = value;
                                  }));
                          memberModel.getAllRank().then((value) => setState(() {
                                rank = value.toList();
                              }));
                        });
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      Mission(save: () {
                        setState(() {
                          profileModel
                              .getProfile()
                              .then((value) => setState(() {
                                    profile = value;
                                  }));
                          memberModel.getAllRank().then((value) => setState(() {
                                rank = value.toList();
                              }));
                        });
                      }),
                      const ShopProductPage(),
                      const ShopServicesPage(),
                      // const VoucherPage(),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  )))),
    );
  }
}
