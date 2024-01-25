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
import 'package:ngoc_huong/screen/gift_shop/chi_tiet_uu_dai.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class AllVoucherScreen extends StatefulWidget {
  const AllVoucherScreen({super.key});

  @override
  State<AllVoucherScreen> createState() => _AllVoucherScreenState();
}

String showIndex = "";

class _AllVoucherScreenState extends State<AllVoucherScreen> {
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

  void addToCart(Map item) async {
    Map data = {
      "DetailList": [
        {
          "Amount": item["PriceOutbound"] * 1,
          "Price": item["PriceOutbound"],
          "PrinceTest": item["PriceOutbound"] * 1,
          "ProductCode": item["Code"],
          "ProductId": item["Id"],
          "Quantity": 1,
        }
      ]
    };
    print("================ Data ==================");
    print(data);
    print("================ Data ==================");
    customModal.showAlertDialog(context, "error", "Giỏ hàng",
        "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
      Navigator.of(context).pop();
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        cartModel.addToCart(data).then((value) {
          print("================ Value ==================");
          print(value);
          print("================ Value ==================");
          EasyLoading.dismiss();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCartSuccess()));
        });
      });
    }, () => Navigator.of(context).pop());
  }

  void updateCart(Map item) async {
    customModal.showAlertDialog(context, "error", "Giỏ hàng",
        "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
      Navigator.of(context).pop();
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        cartModel.updateProductInCart({
          "Id": 1,
          "DetailList": [
            {
              ...item,
              "Amount": (item["Quantity"] + 1) * item["Price"],
              "Quantity": item["Quantity"] + 1
            }
          ]
        }).then((value) {
          EasyLoading.dismiss();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCartSuccess()));
        });
      });
    }, () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: 100,
                child: const MyBottomMenu(
                  active: 0,
                )),
            appBar: AppBar(
              primary: false,
              elevation: 0.0,
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
              title: const Text("Quà đối tác",
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
                                              height: 275,
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
                                                            child: Image.asset(
                                                              "assets/images/voucher1.png",
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Voucher giảm 200k cho tất cả dịch vụ",
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: mainColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                                                  "400",
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
