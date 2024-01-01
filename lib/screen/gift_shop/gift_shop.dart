import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/gift_shop/allProduct.dart';
import 'package:ngoc_huong/screen/gift_shop/allService.dart';
import 'package:ngoc_huong/screen/gift_shop/allVoucher.dart';
import 'package:ngoc_huong/screen/gift_shop/product.dart';
import 'package:ngoc_huong/screen/gift_shop/service.dart';
import 'package:ngoc_huong/screen/gift_shop/voucher.dart';
import 'package:ngoc_huong/screen/home/prodouct.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:upgrader/upgrader.dart';

class GiftShop extends StatefulWidget {
  const GiftShop({super.key});

  @override
  State<GiftShop> createState() => _GiftShopState();
}

class _GiftShopState extends State<GiftShop> {
  final ProfileModel profileModel = ProfileModel();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
  }

  String checkRank(int point) {
    if (point <= 100) {
      return "Bạc";
    } else if (point > 100 && point <= 250) {
      return "Vàng";
    } else if (point > 250 && point <= 500) {
      return "Bạch kim";
    } else if (point > 500) {
      return "Kim cương";
    }
    return "Bạc";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
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
            title: const Text("Shop quà tặng",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          bottomNavigationBar: const MyBottomMenu(active: 4),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                      future: profileModel.getProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map profile = snapshot.data!;
                          return Row(
                            children: [
                              // Expanded(
                              //     child: GestureDetector(
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 10, vertical: 10),
                              //     margin: const EdgeInsets.only(right: 5),
                              //     decoration: BoxDecoration(
                              //         borderRadius: const BorderRadius.all(
                              //             Radius.circular(6)),
                              //         color: Colors.amber.withOpacity(0.3)),
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text(
                              //           "${profile["Point"] ?? 0} điểm",
                              //           style: const TextStyle(
                              //               fontSize: 12,
                              //               fontWeight: FontWeight.w600),
                              //         ),
                              //         const Icon(
                              //           Icons.keyboard_arrow_right,
                              //           size: 20,
                              //           weight: 300,
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // )),

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
                                            Text("${profile["CustomerName"]}"),
                                            Text(
                                                "Hạng ${profile["Point"] == null ? "Bạc" : checkRank(profile["Point"])}"),
                                            Row(
                                              children: [
                                                const Text("Xu đang có: "),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Text(
                                                  "5",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Image.asset(
                                                  "assets/images/icon/Xu.png",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ],
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
                          );
                        } else {
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: LoadingIndicator(
                                colors: kDefaultRainbowColors,
                                indicatorType: Indicator.lineSpinFadeLoader,
                                strokeWidth: 1,
                                // pathBackgroundColor: Colors.black45,
                              ),
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Text("Đang lấy dữ liệu")
                          );
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllProductScreen())),
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
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllServiceScreen())),
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
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllVoucherScreen())),
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
                                "assets/images/Home/Services/thanh-vien.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Quà đối tác",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const ShopProductPage(),
                  const ShopServicesPage(),
                  const VoucherPage(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ))),
    );
  }
}
