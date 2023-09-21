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
import 'package:ngoc_huong/utils/CustomTheme/custom_floating_button.dart';

class SpecialCosmeticScreen extends StatefulWidget {
  const SpecialCosmeticScreen({super.key});

  @override
  State<SpecialCosmeticScreen> createState() => _SpecialCosmeticScreenState();
}

String showIndex = "";

class _SpecialCosmeticScreenState extends State<SpecialCosmeticScreen> {
  final ProductModel productModel = ProductModel();
  final CustomModal customModal = CustomModal();
  final CartModel cartModel = CartModel();

  final LocalStorage storageToken = LocalStorage("customer_token");

  @override
  void initState() {
    super.initState();
    setState(() {
      showIndex = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    showIndex = "";
  }

  void addToCart(Map item) async {
    customModal.showAlertDialog(context, "error", "Giỏ hàng",
        "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
      Navigator.pop(context);
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        cartModel.addProductToCart({"quantity": 1, ...item}).then((value) {
          EasyLoading.dismiss();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCartSuccess()));
        });
      });
    }, () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(active: 0),
            floatingActionButton: const CustomFloatingButton(),
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
              title: const Text("Sản phẩm bán chạy",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: FutureBuilder(
              future: productModel.getHotProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      children: [
                        Wrap(
                            runSpacing: 15,
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
                                                      .width /
                                                  2 -
                                              22.5,
                                          height: 230,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                  .all(Radius.circular(6)),
                                              border:
                                                  Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 1)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    // "${item["Image_Name"]}"
                                                    "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                                    fit: BoxFit.cover,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 120,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${item["Name"]}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        showIndex =
                                                        item["Code"];
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty
                                                            .all(Theme.of(
                                                            context)
                                                            .colorScheme
                                                            .primary)),
                                                    child: const Text(
                                                        "Xem thêm",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .white))),
                                              )
                                            ],
                                          )),
                                      if (showIndex.isNotEmpty &&
                                          showIndex == item["Code"])
                                        Positioned.fill(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(6)),
                                                    color: Colors.black
                                                        .withOpacity(0.4)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showIndex = "";
                                                          });
                                                          showModalBottomSheet<
                                                                  void>(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Container(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom),
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.95,
                                                                    child:
                                                                        ProductDetail(
                                                                      details:
                                                                          item,
                                                                    ));
                                                              });
                                                        },
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blue[500],
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          4)),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/eye-white.png",
                                                                    width: 24,
                                                                    height: 24),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                const Text(
                                                                  "Xem chi tiết",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                )
                                                              ],
                                                            ))),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showIndex = "";
                                                          });
                                                          if (storageToken.getItem(
                                                                  "customer_token") ==
                                                              null) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const LoginScreen()));
                                                          } else {
                                                            addToCart(item);
                                                          }
                                                        },
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            4)),
                                                                color: Colors
                                                                    .blue[900]),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/cart-solid-white.png",
                                                                    width: 24,
                                                                    height: 24),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                const Text(
                                                                  "Mua hàng",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                )
                                                              ],
                                                            )))
                                                  ],
                                                )))
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
            )));
  }
}
